alias Points.Report

# Simple Project
(fn ->
   Report.create_project(%{title: "Pritchett's Closets & Blinds"})
 end).()

# Project with one sub-project
(fn ->
   {:ok, project} = Report.create_project(%{title: "Bluth Company"})
   Report.create_sub_project(project, %{title: "Bluth's Original Frozen Banana Stand."})
 end).()

# Project with multiple sub-projects
(fn ->
   {:ok, project} = Report.create_project(%{title: "Dunder Mifflin Paper Company, Inc"})
   Report.create_sub_project(project, %{title: "Scranton branch"})
   Report.create_sub_project(project, %{title: "Akron branch"})
   Report.create_sub_project(project, %{title: "Albany branch"})
   Report.create_sub_project(project, %{title: "Nashua branch"})
   Report.create_sub_project(project, %{title: "Rochester branch"})
   Report.create_sub_project(project, %{title: "Syracuse branch"})
   Report.create_sub_project(project, %{title: "Utica branch"})
 end).()
