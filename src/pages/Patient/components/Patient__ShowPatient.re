let str = React.string;

type state =
  | Loading
  | Loaded(string);

let handleErrorCB = () => {
  Js.log("Error");
};

let handleSucessCB = (send, response) => {
  // let patients =
  //   response
  //   |> Json.Decode.(field("results", Json.Decode.array(PatientInfo.decode)));
  send(_ =>
    Loaded("yes")
  );
};

let getPatientDetails = (id, send, token) => {
  send(state => Loading);
  Api.getWithToken(
    Routes.url("otp/patient/" ++ id ++ "/"),
    token,
    handleSucessCB(send),
    handleErrorCB,
  );
};

let patientCardClasses = patient =>
  "flex flex-col md:flex-row items-start md:items-center justify-between bg-white border-l-3 p-3 md:py-6 md:px-5 mt-4 border-l-4 cursor-pointer rounded-r-lg shadow hover:border-primary-500 hover:text-primary-500 hover:shadow-md "
  ++ (
    PatientInfo.isActive(patient) ? "border-green-500" : "border-orange-400"
  );

let showPatientCard = (patient, send) => {
  <div key={PatientInfo.id(patient)} className={patientCardClasses(patient)}>
    <div className="w-full md:w-3/4">
      <div className="block text-sm md:pr-2">
        <span className="ml-1 font-semibold text-base">
          {str(
             PatientInfo.name(patient)
             ++ " - "
             ++ string_of_int(PatientInfo.age(patient)),
           )}
        </span>
      </div>
      <div className="mt-1 ml-px text-xs text-gray-900">
        <span className="ml-1">
          {"Last updated on "
           ++ PatientInfo.modifiedDate(patient)
              ->DateFns.format("MMMM d, yyyy")
           |> str}
        </span>
      </div>
    </div>
    {<div className="w-auto md:w-1/4 text-xs flex justify-end mt-2 md:mt-0">
       <div
         className="bg-orange-100 border border-yellow-300 flex-shrink-0 leading-normal text-yellow-600 font-semibold px-3 py-px rounded">
         {str(PatientInfo.diseaseStatus(patient))}
       </div>
     </div>}
  </div>;
};

[@react.component]
let make = (~patientInfo, ~token) => {
  let (state, send) = React.useState(() => Loading);

  React.useEffect1(
    () => {
      getPatientDetails(PatientInfo.id(patientInfo), send, token);
      None;
    },
    [|token|],
  );

  <div className="max-w-3xl mx-auto h-full">
    <h1 className="pt-6 text-gray-700 font-semibold text-3xl">
      {str("Medical Records")}
    </h1>
    {showPatientCard(patientInfo, send)}
    {switch (state) {
     | Loading =>
       SkeletonLoading.multiple(~count=3, ~element=SkeletonLoading.card())
     | Loaded(patientDetails) => <div> {str(patientDetails)} </div>
     }}
  </div>;
};
