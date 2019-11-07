# README

* Auth Assumptions
    * Authentication is handled via a external service
    * The authentication service will supply a JWT token that has been signed using a shared key
    * As the system is multi-tenant, if the user has access to multiple tenants then they will have a JWT token for each tenant

* Inspection Type Assumptions
    * Questions + possible answers will be pre-created...
    
* Inspections Assumptions
    * Blank inspections for a inspection type will be pre-populated via another process
    * There will be one inspection per due date
    * They are scheduled based on a start date and re-occur on fixed intervals from that date
    
* Reporting Assumptions
    * The need to report on the top answers for each question for an inspection list is predicted. To support this the data caputured
    will likely be pushed into a more report friendly structure... likely in a reporting database.
    
     
* Design Overview
    * solution should conform to JSON API standard
    * JWT token are used to
        * supply the Client id for which the api is to be queried. 
        * supply the access scopes the user has been granted to allow authorization checks on all actions performed
            * if the token doesn't have the required scope, access is denied with a 401 response
    * all records will be identified by a 32 char uuid. internal database primary keys will not be exposed       
    * Inspection Types are at highest level
        * Under this are the questions that will be asked and the possible answers
        * Then there are the scheduled inspections
            * These have a due date - a completion date will show if they were completed on time
            * There will be a completed flag to show which have been completed
            * There will be a score which totals up the answers questions if completed. It will be null otherwise.
            * submitting answers to all the questions will cause the completed state change
            * answers cannot be submitted for completed inspections
            * you should be able to query inspections via a date range
            * you should be able to paginate?  
            * answers for a inspection will be a seperate endpoint to stop high level queries returning too much data
        
        