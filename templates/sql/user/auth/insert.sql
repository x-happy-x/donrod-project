INSERT INTO auth (user, token, date, app) VALUES({% user %}, '{% token %}', NOW(), '{% app %}')