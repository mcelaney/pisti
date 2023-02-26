defmodule PointsWeb.Components.CoreComponents.Markdown do
  @moduledoc false

  use Phoenix.Component
  import PointsWeb.Components.Primitives

  @doc """
  Renders a header with title.
  """
  attr :class, :string, default: nil
  attr :content, :string, required: true

  def markdown(assigns) do
    ~H"""
    <%= @content
    |> Earmark.as_html!(make_options())
    |> Phoenix.HTML.raw() %>
    """
  end

  def blockquote_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: blockquote_class())
  end

  def code_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: code_class())
  end

  def h1_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h1_class())
  end

  def h2_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h2_class())
  end

  def h3_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h3_class())
  end

  def h4_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h4_class())
  end

  def h5_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h5_class())
  end

  def h6_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: h6_class())
  end

  def hr_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: hr_class())
  end

  def link_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: link_class())
  end

  @todo """
  Using `list-inside` here causes an issue where the text falls on the line below the bullet
  """
  def ol_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: ol_class())
  end

  def p_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: p_class())
  end

  def pre_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: pre_class())
  end

  def table_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: table_class())
  end

  def thead_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: thead_class())
  end

  def td_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: td_class())
  end

  def th_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: th_class())
  end

  def tr_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: tr_class())
  end

  def ul_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: ul_class())
  end

  def img_class_fn do
    &Earmark.AstTools.merge_atts_in_node(&1, class: img_class())
  end

  def make_options do
    Earmark.Options.make_options!(%{
      registered_processors: [
        {"a", link_class_fn()},
        {"blockquote", blockquote_class_fn()},
        {"code", code_class_fn()},
        {"h1", h1_class_fn()},
        {"h2", h2_class_fn()},
        {"h3", h3_class_fn()},
        {"h4", h4_class_fn()},
        {"h5", h5_class_fn()},
        {"h6", h6_class_fn()},
        {"hr", hr_class_fn()},
        {"img", img_class_fn()},
        {"ol", ol_class_fn()},
        {"p", p_class_fn()},
        {"pre", pre_class_fn()},
        {"table", table_class_fn()},
        {"td", td_class_fn()},
        {"th", th_class_fn()},
        {"thead", thead_class_fn()},
        {"tr", tr_class_fn()},
        {"ul", ul_class_fn()}
      ]
    })
  end
end
