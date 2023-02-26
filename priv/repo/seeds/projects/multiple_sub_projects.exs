alias Points.Plan
alias Points.Report

# steps from https://www.pulpandpaper-technology.com/articles/pulp-and-paper-manufacturing-process-in-the-paper-industry

make_tickets = (fn (project) ->
  Plan.create_ticket(project, %{title: "Pulping procedure will be done to separate and clean the fibers"})
  Plan.create_ticket(project, %{title: "Refining procedure will be followed after pulping processes"})
  Plan.create_ticket(project, %{title: "Dilution process to form a thin fiber mixture"})
  Plan.create_ticket(project, %{title: "Formation of fibers on a thin screened"})
  Plan.create_ticket(project, %{title: "Pressurization to enhance the materials density"})
  Plan.create_ticket(project, %{title: "Drying to eliminate the density of materials"})
  Plan.create_ticket(project, %{title: "Finishing procedure to provide a suitable surface for usgae"})
end)

(fn ->
   {:ok, project} = Report.create_project(%{title: "Dunder Mifflin Paper Company, Inc"})
   make_tickets.(project)

   {:ok, sub_project_1} = Report.create_sub_project(project, %{title: "Scranton branch"})
   make_tickets.(sub_project_1)

   {:ok, sub_project_2} = Report.create_sub_project(project, %{title: "Akron branch"})
   make_tickets.(sub_project_2)

   {:ok, sub_project_3} = Report.create_sub_project(project, %{title: "Albany branch"})
   make_tickets.(sub_project_3)

   {:ok, sub_project_4} = Report.create_sub_project(project, %{title: "Nashua branch"})
   make_tickets.(sub_project_4)

   {:ok, sub_project_5} = Report.create_sub_project(project, %{title: "Rochester branch"})
   make_tickets.(sub_project_5)

   {:ok, sub_project_6} = Report.create_sub_project(project, %{title: "Syracuse branch"})
   make_tickets.(sub_project_6)

   {:ok, sub_project_7} = Report.create_sub_project(project, %{title: "Utica branch"})
   make_tickets.(sub_project_7)
 end).()
