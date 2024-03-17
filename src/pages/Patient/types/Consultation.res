type t = {
  id: string,
  facility_name: string,
  encounter_date: option<Js.Date.t>,
  admitted: bool,
  // admitted_to: option<int>,
  assigned_to: option<int>,
  bed_number: option<string>,
  category: option<string>,
  consultation_notes: option<string>,
  course_in_facility: option<string>,
  // diagnosis: option<string>,
  discharge_date: option<Js.Date.t>,
  examination_details: option<string>,
  // existing_medication: option<string>,
  patient_no: option<string>,
  is_kasp: bool,
  is_telemedicine: bool,
  kasp_enabled_date: option<Js.Date.t>,
  last_updated_by_telemedicine: bool,
  other_symptoms: string,
  // prescribed_medication: option<string>,
  referred_to: option<string>,
  suggestion: string,
  suggestion_text: string,
  symptoms: Js.Array.t<int>,
  symptoms_onset_date: option<Js.Date.t>,
  // verified_by: option<string>,
}

let id = t => t.id
let facility_name = t => t.facility_name
let encounter_date = t => t.encounter_date
let admitted = t => t.admitted
// let admitted_to = t => t.admitted_to
let assigned_to = t => t.assigned_to
let bed_number = t => t.bed_number
let category = t => t.category
let consultation_notes = t => t.consultation_notes
let course_in_facility = t => t.course_in_facility
// let diagnosis = t => t.diagnosis
let discharge_date = t => t.discharge_date
let examination_details = t => t.examination_details
// let existing_medication = t => t.existing_medication
let patient_no = t => t.patient_no
let is_kasp = t => t.is_kasp
let is_telemedicine = t => t.is_telemedicine
let kasp_enabled_date = t => t.kasp_enabled_date
let last_updated_by_telemedicine = t => t.last_updated_by_telemedicine
let other_symptoms = t => t.other_symptoms
// let prescribed_medication = t => t.prescribed_medication
let referred_to = t => t.referred_to
let suggestion = t => t.suggestion
let suggestion_text = t => t.suggestion_text
let symptoms = t => t.symptoms
let symptoms_onset_date = t => t.symptoms_onset_date
// let verified_by = t => t.verified_by

let decode = json => {
  open Json.Decode
  {
    id: json |> field("id", string),
    facility_name: json |> field("facility_name", string),
    encounter_date: json |> field("encounter_date", optional(DateFns.decodeISO)),
    admitted: json |> field("admitted", bool),
    // admitted_to: json |> field("admitted_to", optional(int)),
    assigned_to: json |> field("assigned_to", optional(int)),
    bed_number: json |> field("bed_number", optional(string)),
    category: json |> field("category", optional(string)),
    consultation_notes: json |> field("consultation_notes", optional(string)),
    course_in_facility: json |> field("course_in_facility", optional(string)),
    // diagnosis: json |> field("diagnosis", optional(string)),
    discharge_date: json |> field("discharge_date", optional(DateFns.decodeISO)),
    examination_details: json |> field("examination_details", optional(string)),
    // existing_medication: json |> field("existing_medication", optional(string)),
    patient_no: json |> field("patient_no", optional(string)),
    is_kasp: json |> field("is_kasp", bool),
    is_telemedicine: json |> field("is_telemedicine", bool),
    last_updated_by_telemedicine: json |> field("last_updated_by_telemedicine", bool),
    kasp_enabled_date: json |> field("kasp_enabled_date", optional(DateFns.decodeISO)),
    other_symptoms: json |> field("other_symptoms", string),
    // prescribed_medication: json |> field("prescribed_medication", optional(string)),
    referred_to: json |> field("referred_to", optional(string)),
    suggestion: json |> field("suggestion", string),
    suggestion_text: json |> field("suggestion_text", string),
    symptoms: json |> field("symptoms", array(int)),
    symptoms_onset_date: json |> field("symptoms_onset_date", optional(DateFns.decodeISO)),
    // verified_by: json |> field("verified_by", optional(string)),
  }
}
