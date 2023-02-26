alias Points.Report

# Project with one sub-project and no tickets in either
(fn ->
   {:ok, project} = Report.create_project(%{title: "Bluth Company"})
   Report.create_sub_project(project, %{title: "Bluth's Original Frozen Banana Stand."})
 end).()
