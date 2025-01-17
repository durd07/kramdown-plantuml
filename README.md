# Kramdown::PlantUml

[![Gem Version][gem-badge]][gem-url]
[![Ruby Gem][ruby-badge]][ruby-workflow]
[![No Java][no-java-badge]][no-java-workflow]
[![No PlantUML][no-plantuml-badge]][no-plantuml-workflow]
[![Shell][shell-badge]][shell-workflow]
[![Codecov][codecov-badge]][codecov]
[![Codacy Badge][codacy-badge]][codacy]
[![License][license-badge]][license]
[![CLA assistant][cla-badge]][cla]
[![Contributor Covenant][coc-badge]][coc]

`kramdown-plantuml` allows you to use [PlantUML][plantuml] syntax within [fenced
code blocks][fenced] in [Kramdown][kramdown] ([Jekyll][jekyll]'s default
Markdown parser):

````md
```plantuml
@startuml Diagram
actor client
node app
database db
db -> app
app -> client
@enduml
```
````

Using the `plantuml` language identifier in fenced code blocks will allow
`kramdown-plantuml` to pick it up and replace it with a rendered [SVG][svg]
diagram when the Markdown is rendered to HTML. The above diagram will be
replaced with the following (abbreviated) HTML code:

```html
<div class="plantuml">
  <svg>
    <!-- Snip converted SVG code -->
  </svg>
</div>
```

Which in place will be rendered as the following:

![Rendered SVG Diagram][diagram-svg]

If you configure theming (described below), the generated HTML will contain the
name of the configured theme:

```html
<div class="plantuml theme-spacelab">
  <svg>
    <!-- Snip converted SVG code -->
  </svg>
</div>
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'kramdown-plantuml'
```

And then execute:

```sh
bundle install
```

Or install it yourself as:

```sh
gem install kramdown-plantuml
```

And then add the following to your Jekyll site's `_config.yml` file:

```yaml
plugins:
  - "kramdown-plantuml"
```

Then, `bundle exec jekyll build` or `bundle exec jekyll serve` will execute
`kramdown-plantuml`, converting code fenced PlantUML diagrams to beautiful
SVG.

## Requirements

`kramdown-plantuml` is dependent on the Java application [PlantUML], which in
turn is dependent on [Graphviz]. This means that both Java and Graphviz need to
be installed for `kramdown-plantuml` to work.

## Configuration

`kramdown-plantuml` can be configured either directly in the `options` Hash
provided through Kramdown or by `_config.yml` provided through Jekyll.

### Theming

In order to [theme] all PlantUML diagrams fed through `kramdown-plantuml`, you
can configure a global theme with the `plantuml.theme.name` and
`plantuml.theme.directory` properties. Only `name` is required and will allow
any of the built-in themes to be used.

The theme is simply inserted into each PlantUML diagram with the `!theme`
declaration, so this can be centralized in configuration instead of duplicating
it across all diagrams.

Here's an example of how to configure `kramdown-plantuml` to use the `spacelab`
theme in Jekyll's `_config.yml`:

```yaml
kramdown:
  plantuml:
    theme:
      name: spacelab
```

If you have custom, local themes you'd like to use, you need to provide the
`directory` in which they are placed alongside the `name` of the theme you'd
like to use:

```yaml
kramdown:
  plantuml:
    theme:
      name: my-custom-theme
      directory: path/to/themes
```

### Dimensions and Styling

It's possible to customize the dimensions and scale of the diagram by providing
the `width`, `height` and `scale` configuration keys. It's also possible to add
arbitrary styling with the `style` key.

`scale` is applied before the diagram is generated, while `width` and `height`
are applied after, meaning they can be combined (to most likely detrimental
results, but YOLO).

```yaml
kramdown:
  plantuml:
    width: 200px
    height: 100px
    scale: 2
    style: "border: 1px solid black"
```

To remove the `width`, `height` and `style` attributes from the `<svg />`
element, set the key's value to `none`. `scale` does not support a value of
`none` as it does not need to be removed.

```yaml
kramdown:
  plantuml:
    width: none
    height: none
    style: none
```

### Errors

By default, `kramdown-plantuml` will raise an error and crash if something goes
wrong during processing. This can be circumvented by setting the `raise_errors`
configuration key to `false`:

```yaml
kramdown:
  plantuml:
    raise_errors: false
```

The default value of `raise_errors` is `true`.

## Contributing

Bug reports and pull requests are welcome on [GitHub][github]. This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [code of conduct][coc] and sign the
[contributor's license agreement][cla].

### Development

In order to do development on `kramdown-plantuml`, [clone] or [fork]
this repository, perform the changes you want and submit a [pull request][pr].

The easiest way to develop and test `kramdown-plantuml` is to add it as a
[Jekyll][jekyll] plugin installed from a local path in your `Gemfile`:

```ruby
gem 'kramdown-plantuml', path: 'path/to/kramdown-plantuml'
```

Every time you perform a change to `kramdown-plantuml`, you can then, within
the directory of your Jekyll site, do a `bundle install` to bring the changes
in and then start Jekyll up again afterwards with `bundle exec jekyll serve`.

#### Tests

A few tests are exercised with GitHub Actions every time code is pushed to the
repository on GitHub. You can execute these tests locally by first installing
all dependencies as such:

```shell
bundle install # Installs required Ruby Gems
bundle exec rake maven:install # Installs the PlantUML .jar file
```

And then to execute the tests you run the following:

```shell
bundle exec rake
```

## License

The code within this repository is available as open source under the terms of
the [Apache 2.0 License][license] and the [contributor's license
agreement][cla].

[cla-badge]:            https://cla-assistant.io/readme/badge/SwedbankPay/kramdown-plantuml
[cla]:                  https://cla-assistant.io/SwedbankPay/kramdown-plantuml
[clone]:                https://docs.github.com/en/free-pro-team@latest/github/creating-cloning-and-archiving-repositories/cloning-a-repository
[coc-badge]:            https://img.shields.io/badge/Contributor%20Covenant-v2.0%20adopted-ff69b4.svg
[coc]:                  ./CODE_OF_CONDUCT.md
[codacy-badge]:         https://app.codacy.com/project/badge/Grade/de72385f4ca444c18819a3ce8a506638
[codacy]:               https://www.codacy.com/gh/SwedbankPay/kramdown-plantuml/dashboard?utm_source=github.com&amp;utm_medium=referral&amp;utm_content=SwedbankPay/kramdown-plantuml&amp;utm_campaign=Badge_Grade
[codecov-badge]:        https://codecov.io/gh/SwedbankPay/kramdown-plantuml/branch/main/graph/badge.svg?token=U3QJLVG3HY
[codecov]:              https://codecov.io/gh/SwedbankPay/kramdown-plantuml/
[diagram-svg]:          ./spec/examples/network-diagram.svg
[fenced]:               https://www.markdownguide.org/extended-syntax/#syntax-highlighting
[fork]:                 https://docs.github.com/en/free-pro-team@latest/github/getting-started-with-github/fork-a-repo
[gem-badge]:            https://badge.fury.io/rb/kramdown-plantuml.svg
[gem-url]:              https://rubygems.org/gems/kramdown-plantuml
[gems]:                 https://rubygems.org
[github]:               https://github.com/SwedbankPay/kramdown-plantuml/
[graphviz]:             https://graphviz.org/
[jekyll]:               https://jekyllrb.com/
[kramdown]:             https://kramdown.gettalong.org/
[license-badge]:        https://img.shields.io/github/license/SwedbankPay/kramdown-plantuml
[license]:              https://opensource.org/licenses/Apache-2.0
[no-java-badge]:        https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/no-java.yml/badge.svg
[no-java-workflow]:     https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/no-java.yml
[no-plantuml-badge]:    https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/no-plantuml.yml/badge.svg
[no-plantuml-workflow]: https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/no-plantuml.yml
[plantuml]:             https://plantuml.com/
[pr]:                   https://docs.github.com/en/free-pro-team@latest/github/collaborating-with-issues-and-pull-requests/about-pull-requests
[ruby-badge]:           https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/ruby.yml/badge.svg
[ruby-workflow]:        https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/ruby.yml
[shell-badge]:          https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/shell.yml/badge.svg
[shell-workflow]:       https://github.com/SwedbankPay/kramdown-plantuml/actions/workflows/shell.yml
[svg]:                  https://developer.mozilla.org/en-US/docs/Web/SVG
[theme]:                https://plantuml.com/theme
