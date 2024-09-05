## code to prepare `docs` dataset goes here
# Data pasted using datapasta and taken from table at:
# https://eerscmap.usgs.gov/uspvdb/api-doc/
docs <- tibble::tibble(
  key = c("case_id","multi_poly","eia_id","p_state","p_county","ylat","xlong",
          "p_area","p_img_date","p_dig_conf","p_name","p_year","p_pwr_reg",
          "p_tech_pri","p_tech_sec","p_axis","p_azimuth","p_tilt","p_battery",
          "p_cap_ac","p_cap_dc","p_type","p_agrivolt","p_zscore"),
  value_type = c("number (integer)","string",
                 "number (integer)","string","string","number (float)",
                 "number (float)","number (float)","number (integer)",
                 "number (integer)","string","number (integer)","string",
                 "string","string","string","number (integer)",
                 "number (integer)","string","number (float)",
                 "number (float)","string","string","number (float)"),
  key_description = c(
    "Unique stable identification number.",
    "Indicates the facility's polygon type. single— facility is represented by a single part polygon. multi— facility is represented by multipart polygon composed of at least two discontinuous polygons, sharing a single record.",
    "Unique facility identifier from Energy Information Administration (EIA), may be used to link with other EIA data fields.","State where facility is located.",
    "County where facility is located.",
    "Latitude value of a point representation of the LSPV facility's location. For single-array facilities, values are calculated in the center of the array. For multi-part polygons, values are generated within the array that is closest to the centroid of the multipart polygon.",
    "Longitude value of a point representation of the LSPV facility's location. For single-array facilities, values are calculated in the center of the array. For multi-part polygons, values are generated within the array that is closest to the centroid of the multipart polygon.",
    "Area of the facility array(s) in square meters (m2).",
    "Date of the aerial image used to confirm the facility location and geometry. Derived from aerial image vendor (Maxar) metadata.",
    "Level of confidence in project location. 1— Multiphase facility or multiple EIA records with identical location. Single polygon used to represent multiple facilities indistinguishable from one another; attributes may not reflect full scope of facilities. 2—Multiple polygons created, but EIA records are unclear; attributes may not reflect full scope of facilities. 3— Polygon reflects only a part of the facility due to poor image quality; area of polygon may not reflect the full size of array(s). 4— Facility polygon created with high confidence.","Facility name.",
    "Year in which facility installation was completed.",
    "Common abbreviation of regional power authority name.",
    "Electric generation technology type.","Additional detail on panel type.",
    "Array axis type.",
    "Array azimuth (i.e., east-west orientation) in degrees (°).",
    "Tilt angle of panels (i.e., angle of panels from horizontal) in degrees (°).",
    "Indicator of the presence of battery storage at the facility.",
    "Facility AC capacity in megawatts (MW).",
    "Facility DC capacity in megawatts (MW).",
    "General categorization of facility. greenfield—greenfield sites represent the majority of LSPV facilities and occupy land that may have previously been wildland, urbanized, cultivated, or reclaimed. RCRA—Resource Conservation and Recovery Act (RCRA) sites are a specific category of commercial, industrial, and federal facilities that treat, store or dispose of hazardous wastes and that require cleanup under the RCRA Hazardous Waste Corrective Action Program. superfund—superfund sites are inactive or abandoned contaminated facilities or locations where there is an active release or threatened release into the environment of hazardous substances that have been dumped, discharged, emitted or otherwise improperly managed. These sites may include manufacturing and industrial facilities, processing plants, landfills, and mining sites, among others. AML—sites include abandoned hardrock mines and mineral processing sites listed in the Superfund Enterprise Management System. landfill—sites that have been designated as landfills in EPA's RE-Powering Matrix. landfill named—assigned in cases where EPA did not identify the site as a landfill, but the facility name includes the word \"landfill.\" It is possible that these sites have been sufficiently cleaned or were never contaminated to the point of meeting the PCSC designation; thus, they are distinguished from EPA designated landfill sites. PCSC—when no specific designation is provided in EPA's RE-Powering Matrix, \"brownfield\" sites were assigned to a generalized PCSC facility type.",
    "Agrivoltaic facilities make use of the land between panel rows and surrounding arrays for agricultural (i.e., crop production or grazing) and/or ecosystem services (e.g., pollinator habitat). Agrivoltaic projects are categorized into the following designations: crop, crop,es, es, grazing, grazing,es, non-agrivoltaic.",
    "The Z-score of (p_cap_dc/p_area). A Z-score measures how far a record is from the mean of all records in the field in units of standard deviations. Records with high or low Z-scores may have an error in either p_cap_dc or p_area."
  )
)

# Extract type from value_type column
docs$value_type <- gsub("\\)$", "", gsub("number \\(", "", docs$value_type))

# Swap value_type for valid R type
docs$value_type[docs$value_type == "string"] <- "character"
docs$value_type[docs$value_type == "float"] <- "double"

usethis::use_data(docs, overwrite = TRUE)
