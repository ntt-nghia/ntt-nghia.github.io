# Personal Blog with GitHub Pages

This repository contains my personal blog, built with Jekyll and hosted on GitHub Pages. The blog features a clean, minimalist design with a Solarized Light color scheme, monospace typography, and simple content organization.

## Features

- Minimalist design with Solarized Light color scheme
- Tag-based navigation for easy content discovery
- Markdown content with code syntax highlighting
- Automated deployment via GitHub Actions
- SEO-friendly structure

## Repository Structure

```
username.github.io/
├── _config.yml                 # Main Jekyll configuration
├── _layouts/                   # Template layouts
│   ├── default.html            # Base layout template
│   ├── post.html               # Blog post layout with timestamps and tags
│   └── tag.html                # Tag page layout
├── _posts/                     # Blog post content (Markdown files)
│   └── YYYY-MM-DD-title.md     # Individual blog posts
├── _tags/                      # Generated tag pages
├── _scripts/                   # Utility scripts
│   └── tag-generator.rb        # Script for generating tag pages
├── assets/                     # Static assets
│   ├── css/                    # CSS stylesheets
│   │   └── style.scss          # Main stylesheet with Solarized Light theme
│   └── images/                 # Image files used in blog posts
├── docs/                       # Project documentation
│   └── guidelines.md           # Coding guidelines and best practices
├── about.md                    # About page content
├── tags.html                   # Tags index page
├── index.html                  # Home page
├── Gemfile                     # Ruby dependencies
├── .gitignore                  # Git ignore file
└── .github/workflows/          # GitHub Actions workflows
    └── github-pages.yml        # Automated deployment configuration
```

## Getting Started

### Prerequisites

- Ruby (version 2.5.0 or higher)
- Bundler gem
- Git

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/yourusername.github.io.git
   cd yourusername.github.io
   ```

2. Install dependencies:
   ```bash
   # Install the bundler gem if you don't have it
   gem install bundler

   # Install all dependencies specified in the Gemfile
   bundle install
   ```

   This will install all required gems including:
   - github-pages (which includes Jekyll)
   - jekyll-paginate
   - jekyll-feed
   - jekyll-sitemap
   - jekyll-seo-tag
   - Other platform-specific dependencies as needed

### Running Locally

1. Start the local Jekyll server:
   ```bash
   bundle exec jekyll serve
   ```

2. View your site at http://localhost:4000

3. Additional Jekyll server options:
   ```bash
   # Run with draft posts visible
   bundle exec jekyll serve --drafts

   # Run with live reload (automatically refreshes browser)
   bundle exec jekyll serve --livereload

   # Run on a different port
   bundle exec jekyll serve --port 4001

   # Run with verbose output for debugging
   bundle exec jekyll serve --verbose
   ```

### Creating New Posts

1. Create a new Markdown file in the `_posts` directory with the naming convention `YYYY-MM-DD-title.md`
2. Add the required front matter:
   ```yaml
   ---
   layout: post
   title: "Your Post Title"
   date: YYYY-MM-DD HH:MM:SS -0400
   tags: [tag1, tag2, tag3]
   ---
   ```
3. Write your content in Markdown below the front matter
4. Run the tag generator script to update tag pages:
   ```bash
   ruby _scripts/tag-generator.rb
   ```

### Deployment

The site is automatically deployed to GitHub Pages when changes are pushed to the main branch, thanks to the GitHub Actions workflow configuration.

## Customization

### Site Configuration

Edit `_config.yml` to update site-wide settings like:
- Site title and description
- Author information
- Social media links
- Build settings

### Theme Customization

Modify `assets/css/style.scss` to customize the site's appearance. The current theme uses the Solarized Light color scheme with monospace typography for a clean, minimalist look.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- Jekyll - https://jekyllrb.com/
- GitHub Pages - https://pages.github.com/
