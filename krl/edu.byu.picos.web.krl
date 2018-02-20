ruleset edu.byu.picos.web {
  meta {
    use module edu.byu.picos.canvas alias canvas
    shares __testing, my_courses, course, students
  }
  global {
    __testing =
      { "queries": [ { "name": "__testing" }
                   , { "name": "my_courses", "args": [ "term_id" ] }
                   , { "name": "course", "args": [ "id" ] }
                   , { "name": "students", "args": [ "course_id" ] }
                   ]
      , "events": [
                  ]
      }
    course_item = function(c) {
      <<    <li><a href="course.html?id=#{c{"id"}}">#{c{"name"}}</a></li>
>>
    }
    courses_list = function(term_id) {
      t = term_id.as("Number");
      courses = canvas:courses()
                .filter(function(c){(c{"enrollment_term_id"}==t)});
      <<  <ul>
#{courses.map(function(c){course_item(c)}).join("")}  </ul>
>>
    }
    my_courses = function(term_id) {
      <<<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>My Courses</title>
</head>
<body>
#{courses_list(term_id)}</body>
</html>
>>
    }
    course_body = function(c) {
      <<  <h1>#{c{"name"}}</h1>
    <a href="students.html?course_id=#{c{"id"}}">students</a>
>>
    }
    course = function(id) {
      c = canvas:course(id).klog("course");
      <<<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Course #{c{"id"}}</title>
</head>
<body>
#{course_body(c)}</body>
</html>
>>
    }
    student = function(s) {
      <<  #{s{"short_name"}}<br>
>>
    }
    students = function(course_id) {
      s = canvas:students(course_id);
      <<<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Students #{course_id}</title>
</head>
<body>
#{s.map(function(v){student(v)}).join("")}</body>
</html>
>>
    }
  }
}
