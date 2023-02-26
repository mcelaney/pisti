defmodule PointsWeb.Components.Primitives do
  @moduledoc """
  A collection of universal classes for basic use
  """

  def blockquote_class, do: "pl-4 border-l-8 p-8 mb-4 border-slate-200"

  def code_class, do: "font-mono bg-slate-200 p-1"

  def h1_class, do: "mt-4 mb-4 text-6xl"

  def h2_class, do: "mt-4 mb-4 text-5xl"

  def h3_class, do: "mt-2 mb-2 text-4xl"

  def h4_class, do: "mt-2 mb-2 text-3xl"

  def h5_class, do: "mt-4 text-2xl font-bold"

  def h6_class, do: "mt-4 text-xl font-bold"

  def hr_class, do: "my-4"

  def link_class, do: "underline hover:no-underline text-blue-700 dark:text-sky-400"

  def ol_class, do: "list-decimal pl-12"

  def p_class, do: "mb-2"

  def pre_class, do: "font-mono bg-slate-200 p-4 w-full mb-4"

  def table_class, do: "border w-full text-sm text-left text-gray-500 dark:text-gray-400 mb-4"

  def thead_class,
    do: "text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"

  def td_class, do: "border px-6 py-4"

  def th_class, do: "border px-6 py-4 bg-slate-200"

  def tr_class, do: "bg-white border-b dark:bg-gray-800 dark:border-gray-700"

  def ul_class, do: "list-disc list-inside mb-2 ml-8"

  def img_class, do: "max-w-[35%] inline"
end
