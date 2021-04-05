using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Newtonsoft.Json;
using TeisterMask.DataProcessor.ExportDto;

namespace TeisterMask.DataProcessor
{
    using System;

    using Data;

    using Formatting = Newtonsoft.Json.Formatting;

    public class Serializer
    {
        public static string ExportProjectWithTheirTasks(TeisterMaskContext context)
        {

            StringBuilder sb = new StringBuilder();

            XmlSerializer xmlSerializer =
                new XmlSerializer(typeof(ExportProjectDto[]), new XmlRootAttribute("Projects"));

            var namespaces = new XmlSerializerNamespaces();
            namespaces.Add(string.Empty, string.Empty);

            using (StringWriter strWriter = new StringWriter(sb))
            {
                ExportProjectDto[] projects = context.Projects
                    .ToArray()
                    .Where(p => p.Tasks.Count > 0)
                    .Select(x => new ExportProjectDto()
                    {
                        HasEndDate = x.DueDate.HasValue ? "Yes" : "No",
                        Name = x.Name,
                        TasksCount = x.Tasks.Count,
                        Tasks = x.Tasks.Select(x => new ExportTaskDto()
                            {
                                Name = x.Name,
                                Label = x.LabelType.ToString()
                            })
                            .OrderBy(t => t.Name)
                            .ToArray()
                    })
                    .OrderByDescending(p => p.TasksCount)
                    .ThenBy(p => p.Name)
                    .ToArray();

                xmlSerializer.Serialize(strWriter, projects, namespaces);
            }

            return sb.ToString().TrimEnd();


        }

        public static string ExportMostBusiestEmployees(TeisterMaskContext context, DateTime date)
        {
            var employees = context.Employees
                .ToArray()
                .Where(x => x.EmployeesTasks.Any(x => x.Task.OpenDate >= date))
                .Select(e => new
                {
                    Username = e.Username,
                    Tasks = e.EmployeesTasks
                        .Where(x => x.Task.OpenDate >= date)
                        .OrderByDescending(x => x.Task.DueDate)
                        .ThenBy(x => x.Task.Name)
                        .Select(e => new
                        {
                            TaskName = e.Task.Name,
                            OpenDate = e.Task.OpenDate.ToString("d", CultureInfo.InvariantCulture),
                            DueDate = e.Task.DueDate.ToString("d", CultureInfo.InvariantCulture),
                            LabelType = e.Task.LabelType.ToString(),
                            ExecutionType = e.Task.ExecutionType.ToString()
                        })
                        .ToArray()

                })
                .OrderByDescending(e => e.Tasks.Length)
                .ThenBy(e => e.Username)
                .Take(10)
                .ToArray();

            string json = JsonConvert.SerializeObject(employees, Formatting.Indented);

            return json;


        }
    }
}