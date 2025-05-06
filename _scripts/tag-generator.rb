#!/usr/bin/env ruby

require 'yaml'
require 'date'

# Configuration.
POSTS_DIR = '_posts'
TAGS_DIR = '_tags'

# Create tags directory if it doesn't exist
Dir.mkdir(TAGS_DIR) unless Dir.exist?(TAGS_DIR)

# Get all post files
post_files = Dir.glob("#{POSTS_DIR}/*.md")

# Extract tags from posts
all_tags = []
post_files.each do |post_file|
  content = File.read(post_file)

  # Extract YAML front matter
  if content =~ /\A---\s*\n(.*?)\n---\s*\n/m
    front_matter = YAML.safe_load($1, [Date, Time])

    # Get tags from front matter
    if front_matter['tags']
      tags = front_matter['tags']
      tags = [tags] if tags.is_a?(String)
      all_tags.concat(tags)
    end
  end
end

# Remove duplicates and sort
all_tags = all_tags.uniq.sort

# Generate tag pages
all_tags.each do |tag|
  tag_file = "#{TAGS_DIR}/#{tag.downcase.gsub(' ', '-')}.md"

  # Create tag file
  File.open(tag_file, 'w') do |file|
    file.puts "---"
    file.puts "layout: tag"
    file.puts "title: \"Tag: #{tag}\""
    file.puts "tag: #{tag}"
    file.puts "permalink: /tags/#{tag.downcase.gsub(' ', '-')}/"
    file.puts "---"
  end

  puts "Generated tag page for: #{tag}"
end

puts "Tag generation complete. #{all_tags.size} tag pages generated."
