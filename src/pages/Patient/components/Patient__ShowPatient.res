let str = React.string

type state =
  | Loading
  | Loaded(Consultation.t)


let statusLabel = (status: Patient__Types.covidStatus) => {
  switch status {
  | POSITIVE => "w-max-content text-xs bg-red-100 border border-red-300 flex-shrink leading-normal text-red-600 font-semibold px-3 py-px rounded mx-auto"
  | SUSPECTED => "w-max-content text-xs bg-yellow-100 border border-yellow-300 flex-shrink leading-normal text-yellow-400 font-semibold px-3 py-px rounded mx-auto"
  | _ => "w-max-content text-xs bg-yellow-100 border border-yellow-300 flex-shrink leading-normal text-yellow-400 font-semibold px-3 py-px rounded mx-auto"
  }
}

let handleErrorCB = () => Js.log("Error")

let handleSucessCB = (send, response) => {
  let patients = response |> {
    open Json.Decode
    field("last_consultation", Consultation.decode)
  }
  send(_ => Loaded(patients))
}



let getPatientDetails = (id, send, token) => {
  send(_state => Loading)
  Api.getWithToken(
    Routes.url("otp/patient/" ++ (id ++ "/")),
    token,
    handleSucessCB(send),
    handleErrorCB,
  )
}

let symptomToString = symptom => {
  switch symptom {
  | 1 => "ASYMPTOMATIC"
  | 2 => "FEVER"
  | 3 => "SORE THROAT"
  | 4 => "COUGH"
  | 5 => "BREATHLESSNESS"
  | 6 => "MYALGIA"
  | 7 => "ABDOMINAL DISCOMFORT"
  | 8 => "VOMITING/DIARRHOEA"
  | 10 => "SARI"
  | 11 => "SPUTUM"
  | 12 => "NAUSEA"
  | 13 => "CHEST PAIN"
  | 14 => "HEMOPTYSIS"
  | 15 => "NASAL DISCHARGE"
  | 16 => "BODY ACHE"
  | _ => "OTHERS"
  }
}

let showConsultationCard = consultation => {
  <div className="rounded-lg px-4 pt-2 mt-4">
    <div className="grid grid-cols-2 gap-x-3 text-sm">
      <div className="bg-white p-4">
        {switch Consultation.admitted(consultation) {
          | true =>
          <div className="flex">
            <div>
              <div className="rounded-full bg-red-100 p-2 text-center">
                <i className="text-red-400 fas fa-bed" />
              </div>
            </div>
            <div className="m-auto font-bold ml-3">{str("ADMITTED")}</div>
          </div>
          | false =>
            <div className="flex">
              <div>
                <div className="rounded-full bg-green-100 text-center p-2">
                  <i className="text-green-400 text-lg fas fa-bed" />
                </div>
              </div>
              <div className="m-auto ml-3">
                <text className="font-bold">{str("NOT ")}</text>{str("Admitted")}
              </div>
            </div>
        }}
      </div>
      <div className="flex bg-white p-4 text-center">
        <div className="my-auto">
          <div className="rounded-full bg-blue-100 p-2 pl-3 pr-3 text-center">
            <i className="text-blue-600 text-lg fas fa-atom"></i>
          </div>
        </div>
        <div className="m-auto ml-2">{str("Oxygen Saturation")}</div>
      </div>
    </div>

    {switch Consultation.category(consultation) {
        | Some(category) =>
          <div className="flex bg-white p-4 text-center mt-4">
            <div className="my-auto">
              <div className="rounded-full bg-indigo-100 text-center p-2 pl-3 pr-3 text-center">
                <i className="text-indigo-600 text-lg fas fa-th-large" />
              </div>
            </div>
            <div
              className="p-4 flex justify-around">
              <div className="leading-5 font-semibold text-gray-500 mr-3"> {str("Category:")} </div>
              <div className="font-semibold text-sm leading-5 text-gray-900">
                {str(category)}
              </div>
            </div>
          </div>
        | None => React.null
      }}

      {switch Consultation.consultation_notes(consultation) {
        | Some(notes) =>

          <div className="flex bg-white p-4 mt-4">
            <div className="my-auto">
              <div className="rounded-full bg-red-100 text-center p-2 pl-3 pr-3 text-center">
                <i className="text-red-600 text-lg fas fa-stethoscope" />
              </div>
            </div>

            <div
              className="p-4 lg:flex">
              <div className="leading-5 font-semibold text-gray-500 mr-3"> {str("Consultation Notes:")} </div>
              <div className="font-semibold text-sm leading-5 text-gray-900 sm:mt-2 lg:mt-0">
                {str(notes)}
              </div>
            </div>
          </div>
        | None => React.null
      }}

      {switch Consultation.examination_details(consultation) {
        | Some(examination) =>

          <div className="flex bg-white p-4 mt-4">
            <div className="my-auto">
              <div className="rounded-full bg-purple-100 text-center p-2 pl-3 pr-3 text-center">
                <i className="text-purple-600 text-lg fas fa-notes-medical" />
              </div>
            </div>

            <div
              className="p-4 lg:flex">
              <div className="leading-5 font-semibold text-gray-500 mr-3"> {str("Examination Details:")} </div>
              <div className="font-semibold text-sm leading-5 text-gray-900 sm:mt-2 lg:mt-0">
                {str(examination)}
              </div>
            </div>
          </div>
        | None => React.null
        }}

      <div className="bg-white mt-4 p-4 pb-0">
          <div className="flex bg-white p-4 pl-0 mt-4">
            <div className="my-auto">
              <div className="rounded-full bg-pink-100 text-center p-2 pl-3 pr-3 text-center">
                <i className="text-pink-600 text-lg fas fa-user" />
              </div>
            </div>
            <div className="ml-3 font-bold text-lg my-3">{str("Patient Details")}</div>
          </div>

          <div className="grid grid-cols-1 text-sm mt-2">

            {switch Consultation.encounter_date(consultation) {
            | Some(date) =>
              <div className="grid grid-cols-2 gap-x-2 pt-3 border-b-2 border-gray-200">
                <div>{str("Admission Date")}</div>
                <div className="max-w-2xl text-sm leading-5 text-gray-500">
                  {str("admission date:" ++ Js.Date.toDateString(date))}
                </div>
              </div>
            | None => React.null
            }}


            <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
              <div className="text-sm leading-5 font-medium text-gray-500">{str("Facility Name:")} </div>
              <div className="text-sm leading-5 text-gray-900">
                {str(Consultation.facility_name(consultation))}
              </div>
            </div>

            {switch Consultation.discharge_date(consultation) {
              | Some(discharge) =>
                  <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
                    <div
                      className="sm:grid sm:mt-5 sm:grid-cols-3 sm:gap-4 sm:border-t sm:border-gray-200 sm:pt-5">
                      {str("Discharge Date")}
                    </div>
                    <div className="text-sm leading-5 text-gray-900 sm:mt-0 sm:col-span-2">
                      {str(Js.Date.toDateString(discharge))}
                    </div>
                  </div>
              | None => React.null
            }}

            {switch Consultation.bed_number(consultation) {
            | Some(bed) =>
                <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
                  <div className="text-sm leading-5 font-medium text-gray-500"> {str("Bed Number")} </div>
                  <div className="text-sm leading-5 text-gray-900 sm:mt-0 sm:col-span-2">
                    {str(bed)}
                  </div>
                </div>
            | None => React.null
            }}

            <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
              <div className="text-sm leading-5 font-medium text-gray-500"> {str("Symptoms")} </div>
              <div
                className="text-sm leading-5 text-gray-900">
                <div className="sm:mt-0 sm:col-span-2 space-y-2 space-x-2">
                  {Js.Array.map(
                    symptom =>
                      <span className="px-2 bg-orange-100 rounded text-xs py-1">
                        {str(symptomToString(symptom))}
                      </span>,
                    Consultation.symptoms(consultation),
                  )->React.array}
                </div>
              </div>
            </div>
          </div>
      </div>
    </div>
}

let showCovidStatus = (patient) => {
  <div key={PatientInfo.id(patient)} className="rounded-lg px-4 py-2 mt-4">
    <div
      className="bg-white p-4 flex border-gray-200">
      <div className="text-sm leading-5 font-medium text-gray-500 mr-4"> {str("Covid-19 Status")} </div>
      <div className="text-center">
        <div className={statusLabel(Patient__Types.getStatusType(PatientInfo.diseaseStatus(patient)))}>
          {str(PatientInfo.diseaseStatus(patient))}
        </div>
      </div>
    </div>
  </div>
}

let showPatientCard = (patient, _send) => {
  <div className="bg-gray-100 p-4 pt-0">
    <div className="bg-white grid grid-cols-1 text-sm p-4 pt-0">
      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Date of Birth")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(PatientInfo.dateOfBirth(patient))}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Mobile Number")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(PatientInfo.phoneNumber(patient))}
          </div>
        </div>
      </div>


      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Blood Group")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(PatientInfo.bloodGroup(patient)->Belt.Option.getWithDefault("-"))}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Emergency Contact number")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(PatientInfo.emergencyPhoneNumber(patient))}
          </div>
        </div>
      </div>


      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Address")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            <div
              className="mt-1 text-sm leading-5 text-gray-900 sm:mt-0 sm:col-span-2 whitespace-pre-wrap">
              {str(PatientInfo.address(patient))}
              {PatientInfo.pincode(patient)->Belt.Option.mapWithDefault(React.null, p =>
                <div> {str("Pincode: " ++ string_of_int(p))} </div>
              )}
              {PatientInfo.districtObject(patient)->Belt.Option.mapWithDefault(React.null, p =>
                <div> {str("District: " ++ District.name(p))} </div>
              )}
              {PatientInfo.localBodyObject(patient)->Belt.Option.mapWithDefault(React.null, p =>
                <div> {str("District: " ++ LocalBody.name(p))} </div>
              )}
              {PatientInfo.wardObject(patient)->Belt.Option.mapWithDefault(React.null, p =>
                <div> {str("District: " ++ Ward.name(p))} </div>
              )}
            </div>
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Gender")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(
              switch PatientInfo.gender(patient) {
              | 1 => "Male"
              | 2 => "Female"
              | _ => ""
              },
            )}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Number Of Aged Dependents")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(string_of_int(PatientInfo.numberOfAgedDependents(patient)))}
          </div>
        </div>
      </div>

      <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
        <div className="text-sm leading-5 font-medium text-gray-500"> {str("Number Of Chronic Diseased Dependents")} </div>
        <div className="text-sm leading-5 text-gray-900">
          <div className="sm:mt-0 sm:col-span-2">
            {str(string_of_int(PatientInfo.numberOfChronicDiseasedDependents(patient)))}
          </div>
        </div>
      </div>


      {switch PatientInfo.facilityObject(patient) {
      | Some(facility) =>

        <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
          <div className="text-sm leading-5 font-medium text-gray-500"> {str("Last visited facility")} </div>
          <div className="text-sm leading-5 text-gray-900">
            <div className="sm:mt-0 sm:col-span-2">
              {str(Facility.name(facility))}
            </div>
          </div>
        </div>
      | None => React.null
      }}

      {switch PatientInfo.willDonateBlood(patient) {
      | Some(willDonateBlood) =>

        <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
          <div className="text-sm leading-5 font-medium text-gray-500"> {str("Willing to Donate Blood")} </div>
          <div className="text-sm leading-5 text-gray-900">
            <div className="sm:mt-0 sm:col-span-2">
              {str(willDonateBlood ? "Yes" : "No")}
            </div>
          </div>
        </div>
      | None => React.null
      }}

      {switch PatientInfo.isDeclaredPositive(patient) {
      | Some(isDeclaredPositive) =>

        <div className="grid grid-cols-2 gap-x-2 mt-3 mb-2 pt-3 pb-2 border-b-2 border-gray-200">
          <div className="text-sm leading-5 font-medium text-gray-500"> {str("Has been declared postive")} </div>
          <div className="text-sm leading-5 text-gray-900">
            <div className="sm:mt-0 sm:col-span-2">
              {str(isDeclaredPositive ? "Yes" : "No")}
            </div>
          </div>
        </div>

      | None => React.null
      }}
    </div>
  </div>
}

@react.component
let make = (~patientInfo, ~token) => {
  let (state, send) = React.useState(() => Loading)

  React.useEffect1(() => {
    getPatientDetails(PatientInfo.id(patientInfo), send, token)
    None
  }, [token])

  <div className="max-w-3xl mx-auto h-full">
    <div className="bg-yellow-50 border-l-4 border-yellow-400 p-4 mt-2">
      <div className="flex">
        <div className="flex-shrink-0"> <i className="text-yellow-700 fas fa-check" /> </div>
        <div className="ml-3">
          <p className="text-sm leading-5 text-yellow-700">
            {str(
              "Share your medical records with the hospital by sharing your phone number and date of birth.",
            )}
          </p>
        </div>
      </div>
    </div>
    <h1 className="pt-6 text-gray-700 font-semibold text-3xl">
      {str(PatientInfo.name(patientInfo))}
    </h1>
    <div className="font-mono text-xs"> {str("Unique Id: " ++ PatientInfo.id(patientInfo))} </div>
    <div className="bg-gray-100">
      {showCovidStatus(patientInfo)}
      {switch state {
      | Loading => SkeletonLoading.multiple(~count=3, ~element=SkeletonLoading.card())
      | Loaded(consultation) => <div> {showConsultationCard(consultation)} </div>
      }}
      {showPatientCard(patientInfo, send)}
    </div>
  </div>
}
