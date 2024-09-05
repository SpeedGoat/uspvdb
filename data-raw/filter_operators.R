## code to prepare `filter_operators` dataset goes here

# Taken from: https://eerscmap.usgs.gov/uspvdb/api-doc/

filter_operators <- tibble::tribble(
  ~Operator, ~Meaning,~Example.of.Operator.in.Request,
  "eq", "equals","projects?&p_state=eq.AZ  Return facilities that are located in Arizona.",
  "gt", "greater than", "projects?&p_cap_ac=gt.50&p_state=eq.OH  Return facilities that have an AC capacity greater than 50 MW and are located in Ohio.",
  "gte", "greater than or equal", "projects?&p_tilt=gte.5&p_year=eq.2018  Return facilities that have a panel tilt angle greater or equal to 5 degrees that were constructed in 2018.",
  "lt", "less than", "projects?&p_dig_conf=lt.3&p_type=eq.greenfield  Return facilities with levels of confidence less than 3 (see attribute definitions for p_dig_conf in table above) that are categorized as Greenfield projects.",
  "lte", "less than or equal", "projects?&p_dig_conf=lte.2&ylat=gt.42  Return facilities with levels of confidence less than or equal to 2 (see attribute definitions for p_dig_conf in table above) and are north of 42° latitude.",
  "neq", "not equal", "projects?&p_type=neq.greenfield&select=count  Count the number of facilities that are not categorized as Greenfield projects. Note that you can return a count on any query by simply appending &select=count to the query string.",
  "like", "LIKE operator (use * as wildcard)", "projects?&p_county=like.*Car*&order=case_id  Return facilities that have the string \"Car\" (case-sensitive) in the name of county that the facility resides, and return them in order of case ID. Note the like operator is case-sensitive (use ilike operator for case-insensitive queries).",
  "ilike", "ILIKE operator (use * as wildcard)", "projects?&p_name=ilike.*solar*&order=p_year.desc  Return facilities that have the string \"solar\" in the name (case-insensitive), and order by most recent install year. Note the ilike operator is case-insensitive.",
  "in", "one of a list of values", "projects?&p_state=in.(VA,WV)&select=p_name,p_year  Return facilities that are located in either Virginia or West Virginia, and only show the keys \"facility name\" and \"installation year\" in response.",
  "is", "checking for exact equality (null,true,false)", "projects?&or=(p_cap_ac.is.null,p_cap_ac.gte.220)  Return facilities where capacity (AC) is either null or is greater than or equal to 220 MW. Note that multiple parameters are logically disjoined by using or.",
  "not", "negates another operator", "projects?&and=(p_name.not.ilike.*Solar*,p_cap_dc.gt.300)  Return facilities where the manufacturer name does not contain \"Solar\" and facility capacity (DC) is greater or equal to 300 MW. Note that multiple parameters are logically conjoined by using and."
)

usethis::use_data(filter_operators, internal = TRUE, overwrite = TRUE)
