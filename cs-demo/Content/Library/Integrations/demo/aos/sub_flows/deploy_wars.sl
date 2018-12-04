namespace: Integrations.demo.aos.sub_flows
flow:
  name: deploy_wars
  inputs:
    - tomcat_host: "${get_sp('host1')}"
    - account_service_host: "${get_sp('host2')}"
    - db_host: "${get_sp('host3')}"
    - username: "${get_sp('vm_username')}"
    - password: "${get_sp('vm_password')}"
    - url: "${get_sp('war_repo_root_url')}"
  workflow:
    - deploy_account_service:
        do:
          Integrations.demo.aos.sub_flows.initialize_artifact:
            - host: '${account_service_host}'
            - username: "${get_sp('vm_username')}"
            - password: "${get_sp('vm_password')}"
            - articfact_url: "${url+'accountservice/target/accountservice.war'}"
            - script_url: deploy_war.sh
            - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
        navigate:
          - FAILURE: on_failure
          - SUCCESS: deploy_tm_wars
    - deploy_tm_wars:
        loop:
          for: "war in 'catalog','MasterCredit','order','ROOT','ShipEx','SafePay'"
          do:
            Integrations.demo.aos.sub_flows.initialize_artifact:
              - host: '${tomcat_host}'
              - articfact_url: "${url+war.lower()+'/target/'+war+'.war'}"
              - parameters: "${db_host+' postgres admin '+tomcat_host+' '+account_service_host}"
          break:
            - FAILURE
        navigate:
          - FAILURE: on_failure
          - SUCCESS: SUCCESS
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      deploy_account_service:
        x: 232
        y: 134
      deploy_tm_wars:
        x: 437
        y: 138
        navigate:
          508b0a93-3657-3008-a7d6-e48240b977be:
            targetId: 398e10d0-23ef-e139-c74e-8d8f46ef3dfb
            port: SUCCESS
    results:
      SUCCESS:
        398e10d0-23ef-e139-c74e-8d8f46ef3dfb:
          x: 698
          y: 125
