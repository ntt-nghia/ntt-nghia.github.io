# GitHub Pages Blog Guidelines

This document provides comprehensive guidelines for understanding the codebase, conventions, testing approach, and clean code principles used in this personal blog repository.

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
│   └── css/                    # CSS stylesheets
│       └── style.scss          # Main stylesheet with dark theme
├── about.md                    # About page content
├── tags.html                   # Tags index page
├── index.html                  # Home page
├── Gemfile                     # Ruby dependencies
└── .github/workflows/          # GitHub Actions workflows
    └── github-pages.yml        # Automated deployment configuration
```

## Naming Conventions

### File Naming

1. **Blog Posts**: `YYYY-MM-DD-kebab-case-title.md`
2. **Tag Pages**: `lowercase-tag-name.md`
3. **Layouts**: `descriptive-name.html`
4. **Stylesheets**: `descriptive-name.scss` or `descriptive-name.css`

### Code Conventions

1. **Liquid Template Variables**: Use snake_case for variables (`post_title`, `tag_name`)
2. **CSS Class Names**: Use kebab-case for class names (`post-meta`, `tag-pill`)
3. **HTML IDs**: Use kebab-case for IDs (`main-content`, `site-header`)

## Jekyll and Liquid Syntax Guidelines

1. **Front Matter**: Always include required front matter at the top of content files:
   ```yaml
   ---
   layout: post
   title: "Post Title"
   date: YYYY-MM-DD HH:MM:SS -0400
   tags: [tag1, tag2, tag3]
   ---
   ```

2. **Liquid Tags**:
   - Outputs: `{{ variable }}`
   - Logic: `{% if condition %}...{% endif %}`
   - Loops: `{% for item in collection %}...{% endfor %}`
   - Filters: `{{ variable | filter }}`

3. **Includes**: Use includes for reusable components:
   ```liquid
   {% include header.html %}
   ```

## Clean Code Principles

1. **DRY (Don't Repeat Yourself)**
   - Use Jekyll includes for repeated HTML sections
   - Use SCSS variables and mixins for repeated styles
   - Create reusable layouts for similar page types

2. **Separation of Concerns**
   - Content (Markdown) should be separate from presentation (layouts)
   - Use CSS for styling, not inline styles
   - Use data files for configuration, not hardcoded values

3. **Readability**
   - Use meaningful variable and file names
   - Include whitespace and indentation consistently
   - Add HTML comments for complex sections

4. **Maintainability**
   - Organize code into logical folders
   - Keep files small and focused on a single purpose
   - Document complex logic

## Testing Guidelines

1. **Local Testing**
   - Always test changes locally before pushing:
     ```bash
     bundle exec jekyll serve
     ```
   - Check site at http://localhost:4000

2. **Cross-browser Testing**
   - Test on multiple browsers (Chrome, Firefox, Safari, Edge)
   - Test on mobile devices or using browser dev tools mobile view

3. **Responsive Design Testing**
   - Verify layouts at different screen sizes
   - Test navigation on mobile devices

4. **Performance Testing**
   - Check page load times
   - Optimize image sizes
   - Minimize CSS and JavaScript

5. **Validation**
   - Validate HTML: [W3C Validator](https://validator.w3.org/)
   - Validate CSS: [W3C CSS Validator](https://jigsaw.w3.org/css-validator/)
   - Check for broken links periodically

## Extended Thinking Approaches

When analyzing or modifying this codebase, employ these strategies:

1. **Understand the Purpose**
   - Each file and component has a specific purpose in the Jekyll ecosystem
   - Consider how changes affect the build process and generated site

2. **Think about User Experience**
   - Is the navigation intuitive?
   - Do blog posts load quickly?
   - Is content easy to read in dark mode?

3. **Consider SEO Impact**
   - Use proper heading hierarchy
   - Include metadata in front matter
   - Ensure descriptive URLs and titles

4. **Anticipate Content Growth**
   - How will the design handle dozens or hundreds of posts?
   - Will the tag system become unwieldy with many tags?

5. **Evaluate Dependencies**
   - Minimize external dependencies
   - Keep GitHub Pages compatibility in mind

## Best Practices for Blog Content

1. **Blog Post Structure**
   - Use clear, descriptive titles
   - Add an introductory paragraph
   - Use heading hierarchy (H1, H2, H3) appropriately
   - Include relevant tags (3-5 per post)

2. **Code Snippets in Posts**
   - Use fenced code blocks with language specified:
     ````markdown
     ```java
     @SpringBootApplication
     public class Application {
         public static void main(String[] args) {
             SpringApplication.run(Application.class, args);
         }
     }
     ```
     ````

3. **Images**
   - Store in `/assets/images/`
   - Use meaningful filenames
   - Include alt text for accessibility
   - Optimize for web (compress before uploading)

4. **Links**
   - Use relative URLs for internal links
   - Include descriptive link text

## Deployment Process

1. **Automatic Deployment**
   - GitHub Actions automatically builds and deploys the site when changes are pushed to the main branch
   - The workflow is defined in `.github/workflows/github-pages.yml`

2. **Manual Deployment (if needed)**
   - Build the site locally: `bundle exec jekyll build`
   - Push the generated `_site` directory to the `gh-pages` branch

## Troubleshooting

Common issues and their solutions:

1. **Missing Dependencies**
   - Run `bundle install` to install required gems

2. **Build Failures**
   - Check Jekyll build output for errors
   - Verify YAML front matter syntax in content files

3. **CSS Not Applying**
   - Ensure SCSS files have front matter (even if empty)
   - Check for syntax errors in CSS/SCSS

4. **Tag Pages Not Generating**
   - Run the tag generator script: `ruby _scripts/tag-generator.rb`
   - Check tag format in blog post front matter

5. **GitHub Pages Build Failures**
   - Check repository Settings > Pages for error messages
   - Verify GitHub Actions workflow logs