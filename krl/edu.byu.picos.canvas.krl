ruleset edu.byu.picos.canvas {
  meta {
    shares __testing, courses, course, students
    provides courses, course, students
  }
  global {
    __testing =
    { "queries": [ { "name": "__testing" }
                 , { "name": "courses" }
                 , { "name": "course", "args": [ "id" ] }
                 , { "name": "students", "args": [ "course_id" ] }
                 ]
    , "events": [ { "domain": "canvas", "type": "new_access_token", "attrs": [ "access_token" ] }
                ]
    }
    prefix = "https://byu.instructure.com/api/v1"
    courses = function() {
      http:get(prefix+"/courses",
        headers = {"Authorization": "Bearer "+ent:access_token}
      ){"content"}.decode()
    }
    course = function(id) {
      http:get(prefix+"/courses/"+id,
        headers = {"Authorization": "Bearer "+ent:access_token}
      ){"content"}.decode()
    }
    students = function(course_id) {
      http:get(prefix+"/courses/"+course_id+"/users?per_page=100",
        form = {"enrollment_type[]": "student"},
        headers = {"Authorization": "Bearer "+ent:access_token}
      ){"content"}.decode()
    }
  }
  rule canvas_new_access_token {
    select when canvas new_access_token access_token re#(.+)# setting(access_token)
    fired {
      ent:access_token := access_token
    }
  }
}
