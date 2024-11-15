using { sapbackend as external } from './external/sapbackend';


define service SAPBackendExit {
   @cds.persistence : {
        table,
        skip: false
    }
    @cds.autoexpose
    entity Incidents as projection on external.IncidentsSet;
    //entity Files as select from external.FilesSet;
    //entity Signature as projection on external.SignatureSet;
}