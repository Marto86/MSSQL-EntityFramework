﻿using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Xml.Serialization;
using Newtonsoft.Json;
using TeisterMask.Data.Models;
using TeisterMask.Data.Models.Enums;
using TeisterMask.DataProcessor.ImportDto;

namespace TeisterMask.DataProcessor
{
    using System;
    using System.Collections.Generic;

    using System.ComponentModel.DataAnnotations;

    using Data;

    using ValidationContext = System.ComponentModel.DataAnnotations.ValidationContext;

    public class Deserializer
    {
        private const string ErrorMessage = "Invalid data!";

        private const string SuccessfullyImportedProject
            = "Successfully imported project - {0} with {1} tasks.";

        private const string SuccessfullyImportedEmployee
            = "Successfully imported employee - {0} with {1} tasks.";

        public static string ImportProjects(TeisterMaskContext context, string xmlString)
        {

            StringBuilder sb = new StringBuilder();
            XmlSerializer xmlSerializer = new XmlSerializer(typeof(ProjectImportDto[]), new XmlRootAttribute("Projects"));

            List<Project> projectsToAdd = new List<Project>();

            using (StringReader reader = new StringReader(xmlString))
            {
                ProjectImportDto[] projectDtOs = (ProjectImportDto[])xmlSerializer.Deserialize(reader);


                foreach (var projectDtO in projectDtOs)
                {
                    if (!IsValid(projectDtO))
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    DateTime openDate;
                    bool isValidOpenDate = DateTime.TryParseExact(projectDtO.OpenDate, "dd/MM/yyyy",
                        CultureInfo.InvariantCulture, DateTimeStyles.None, out openDate);

                    if (!isValidOpenDate)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    DateTime? dueDate;
                    if (!String.IsNullOrEmpty(projectDtO.DueDate))
                    {
                        DateTime projectDueDate;
                        bool isvalidDueDate = DateTime
                            .TryParseExact(projectDtO.DueDate, "dd/MM/yyyy", CultureInfo.InvariantCulture, DateTimeStyles.None, out projectDueDate);

                        if (!isvalidDueDate)
                        {
                            sb.AppendLine(ErrorMessage);
                            continue;
                        }

                        dueDate = projectDueDate;
                    }
                    else
                    {
                        dueDate = null;
                    }

                    Project project = new Project()
                    {
                        Name = projectDtO.Name,
                        OpenDate = openDate,
                        DueDate = dueDate
                    };

                    foreach (var taskDto in projectDtO.Tasks)
                    {

                        if (!IsValid(taskDto))
                        {
                            sb.AppendLine(ErrorMessage);
                            continue;
                        }

                        DateTime taskOpenDate;
                        bool isValidTaskOpdenDate = DateTime.TryParseExact(taskDto.OpenDate, "dd/MM/yyyy",
                            CultureInfo.InvariantCulture, DateTimeStyles.None,
                            out taskOpenDate);

                        if (!isValidTaskOpdenDate)
                        {
                            sb.AppendLine(ErrorMessage);
                            continue;
                        }

                        if (taskOpenDate < project.OpenDate)
                        {
                            sb.AppendLine(ErrorMessage);
                            continue;
                        }

                        DateTime taskDueDate;
                        bool isValidTaskDueDate = DateTime.TryParseExact(taskDto.DueDate, "dd/MM/yyyy",
                            CultureInfo.InvariantCulture, DateTimeStyles.None,
                            out taskDueDate);

                        if (!isValidTaskDueDate)
                        {
                            sb.AppendLine(ErrorMessage);
                            continue;
                        }

                        if (project.DueDate.HasValue)
                        {
                            if (taskDueDate > project.DueDate)
                            {
                                sb.AppendLine(ErrorMessage);
                                continue;
                            }
                        }


                        Task task = new Task()
                        {
                            Name = taskDto.Name,
                            OpenDate = taskOpenDate,
                            DueDate = taskDueDate,
                            ExecutionType = (ExecutionType)taskDto.ExecutionType,
                            LabelType = (LabelType)taskDto.LabelType,

                        };
                        project.Tasks.Add(task);

                    }

                    projectsToAdd.Add(project);
                    sb.AppendLine(string.Format($"SuccessfullyImportedProject,{project.Name}, {project.Tasks.Count}"));
                }

                context.Projects.AddRange(projectsToAdd);
                context.SaveChanges();

                return sb.ToString().TrimEnd();
            }
        }

        public static string ImportEmployees(TeisterMaskContext context, string jsonString)
        {
            StringBuilder sb = new StringBuilder();
            EmployeeImportDto[] employeesDto = JsonConvert.DeserializeObject<EmployeeImportDto[]>(jsonString);

            List<Employee> employeesToAdd = new List<Employee>();

            foreach (var employeeImport in employeesDto)
            {
                if (!IsValid(employeeImport))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }

                

                if (!UserValidation(employeeImport.Username))
                {
                    sb.AppendLine(ErrorMessage);
                    continue;
                }
                Employee employee = new Employee()
                {
                    Username = employeeImport.Username,
                    Email = employeeImport.Email,
                    Phone = employeeImport.Phone,
                };

                foreach (int taskId in employeeImport.Tasks.Distinct())
                {
                    Task task = context.Tasks
                        .FirstOrDefault(t => t.Id == taskId);

                    if (task == null)
                    {
                        sb.AppendLine(ErrorMessage);
                        continue;
                    }

                    employee.EmployeesTasks.Add(new EmployeeTask()
                    {
                        Employee = employee,
                        Task = task
                    });
                }

                employeesToAdd.Add(employee);
                sb.AppendLine(string.Format($"SuccessfullyImportedEmployee, {employee.Username}, {employee.EmployeesTasks.Count}"));
            }

            context.Employees.AddRange(employeesToAdd);
            context.SaveChanges();
            return sb.ToString().TrimEnd();
        }

        private static bool IsValid(object dto)
        {
            var validationContext = new ValidationContext(dto);
            var validationResult = new List<ValidationResult>();

            return Validator.TryValidateObject(dto, validationContext, validationResult, true);
        }
        private static bool UserValidation(string username)
        {
            foreach (char sign in username)
            {
                if (!char.IsLetterOrDigit(sign))
                {
                    return false;
                }
            }

            return true;
        }
    }
}