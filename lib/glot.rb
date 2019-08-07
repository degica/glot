# frozen_string_literal: true

require 'glot/version'
require 'glot/hash'

module Glot
  class Error < StandardError; end

  class << self
    def prop(content, &block)
      tree = []
      indent_counter = /^(?<indent>[ ]+)(?<objname>:?[a-z0-9\-_]+) *:/

      content.split("\n").each do |line|
        im = indent_counter.match(line)
        if im
          if im[:indent].length.even?
            pos = im[:indent].length / 2
            if tree.length < pos
              tree += [im[:objname]]
            elsif tree.length > pos
              tree = tree[0...pos]
            end
            tree[-1] = im[:objname]
          else
            p line
          end
        end

        yield tree, line if block
      end
    end

    def extract_reference_locations(content)
      references = {}

      refregex = /(?<objname>:?[a-z0-9\-_]+) *: *&(?<refname>[a-z_]+)/

      prop(content) do |tree, line|
        refregex.match(line) do |m|
          references[tree.join('.')] = m[:refname]
        end
      end
      references
    end

    def reapply_references(content, taggedhash)
      idx_to_ref = {}

      lines = []

      decl_regex = /: *&(?<refnum>[0-9]+)/
      ref_regex = /: *\*(?<refnum>[0-9]+)/
      prop(content) do |tree, line|
        theline = line

        decl_regex.match(line) do |m|
          idx_to_ref[m[:refnum]] = taggedhash.reference_names[tree.join('.')]
          theline.sub!(/\&[0-9]+/, "&#{idx_to_ref[m[:refnum]]}")
        end

        ref_regex.match(line) do |m|
          if idx_to_ref[m[:refnum]]
            theline.sub!(/\*[0-9]+/, "*#{idx_to_ref[m[:refnum]]}")
          end
        end

        lines << theline
      end

      lines.join("\n")
    end

    def get_in_hash(str, hash)
      if str.include?('.')
        key = str[/[^\.]+/]
        inner_hash = hash[key]
        if !inner_hash
          nil
        else
          get_in_hash(str.sub("#{key}.", ''), inner_hash)
        end
      else
        if hash[str].is_a?(Hash)
          Hash
        else
          hash[str]
        end
      end
    end

    def find_in(sym, hash)
      hash.deep_traverse do |k, v, _s|
        if v.is_a?(Hash)
          if v.key?(sym.to_s)
            yield path: (k + [sym]).join('.'), v: v[sym.to_s].is_a?(Hash) ? Hash : v[sym.to_s]
          end
        end
      end
    end

    def find(sym, files)
      res = []
      files.each do |_k, v|
        find_in(sym, v) do |x|
          res << x
        end
      end
      res
    end

    def get(str, files)
      res = {}
      files.each do |k, v|
        dstr = str.sub(/^(#{k}\.)/, '')
        res[k] = get_in_hash(dstr, v[k.to_s])
      end
      res
    end

    def set_in_hash(str, hash, val, replace: false)
      if str.include?('.')
        key = str[/[^\.]+/]

        inner_hash = hash[key]
        if !inner_hash
          if hash.is_a?(Hash) && (replace || inner_hash.nil?)
            hash[key] = {}
            set_in_hash(str.sub("#{key}.", ''), hash[key], val, replace: replace)
          end
        else
          set_in_hash(str.sub("#{key}.", ''), inner_hash, val, replace: replace)
        end
      else
        if hash.is_a?(Hash) && !hash[str].is_a?(Hash) && (hash[str].nil? || replace)
          hash[str] = val
        end
      end
    end

    def set(str, files, val, replace: false)
      files.each do |k, v|
        dstr = str.sub(/^(#{k}\.)/, '')
        p v.keys
        p dstr
        set_in_hash(dstr, v[k.to_s], val, replace: replace)
      end
    end
  end
end
