defmodule PointsWeb.Components.CoreComponents.MarkdownTest do
  @moduledoc """
  We're going to assume `Earmark.as_html!/2` works as expected - so these tests
  just make sure the AstTools are adding the expected classes
  """

  use PointsWeb.ConnCase

  import Phoenix.LiveViewTest

  alias PointsWeb.Components.CoreComponents.Markdown
  alias PointsWeb.Components.Primitives

  describe "Header tags" do
    test "h1 tags" do
      result = render_component(&Markdown.markdown/1, content: "# Heading")
      assert result =~ Primitives.h1_class()
    end

    test "h2 tags" do
      result = render_component(&Markdown.markdown/1, content: "## Heading")
      assert result =~ Primitives.h2_class()
    end

    test "h3 tags" do
      result = render_component(&Markdown.markdown/1, content: "### Heading")
      assert result =~ Primitives.h3_class()
    end

    test "h4 tags" do
      result = render_component(&Markdown.markdown/1, content: "#### Heading")
      assert result =~ Primitives.h4_class()
    end

    test "h5 tags" do
      result = render_component(&Markdown.markdown/1, content: "##### Heading")
      assert result =~ Primitives.h5_class()
    end

    test "h6 tags" do
      result = render_component(&Markdown.markdown/1, content: "###### Heading")
      assert result =~ Primitives.h6_class()
    end
  end

  describe "List tags" do
    test "ol tags" do
      content = """
      1. Lorem ipsum dolor sit amet
      2. Consectetur adipiscing elit
      3. Integer molestie lorem at massa
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.ol_class()
    end

    test "ul tags" do
      content = """
      + I am a bullet
      + Bullet 2
        - Sub bullet
      + Bullet 3
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.ul_class()
    end
  end

  test "Table tags" do
    content = """
    | Option | Description |
    | ------ | ----------- |
    | row 1  | data 1      |
    | row 2  | data 2      |
    | row 3  | data 3      |
    """

    result = render_component(&Markdown.markdown/1, content: content)
    assert result =~ Primitives.table_class()
    assert result =~ Primitives.td_class()
    assert result =~ Primitives.th_class()
    assert result =~ Primitives.thead_class()
    assert result =~ Primitives.tr_class()
  end

  describe "Other tags" do
    test "blockquote tags" do
      content = """
      > This is a blockquote
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.blockquote_class()
    end

    test "code tags" do
      content = """
          line 1 of code
          line 2 of code
          line 3 of code
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.code_class()
    end

    test "p tags" do
      content = """
      One paragraph

      Two Paragraphs
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.p_class()
    end

    test "pre tags" do
      content = """
      ```
      Preformatted text...
      ```
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.pre_class()
    end

    test "img tags" do
      content = """
      ![Stormtroopocat](https://octodex.github.com/images/stormtroopocat.jpg "The Stormtroopocat")
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.img_class()
    end

    test "a tags" do
      content = """
      [link with title](http://nodeca.github.io/pica/demo/ "title text!")
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.link_class()
    end

    test "hr tags" do
      content = """
      ---
      """

      result = render_component(&Markdown.markdown/1, content: content)
      assert result =~ Primitives.hr_class()
    end
  end
end
