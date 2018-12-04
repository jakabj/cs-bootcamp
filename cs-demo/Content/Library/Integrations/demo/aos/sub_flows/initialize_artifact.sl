namespace: Integrations.demo.aos.sub_flows
flow:
  name: initialize_artifact
  inputs:
    - host: "${get_sp('host1')}"
    - username: root
    - password: admin@123
    - articfact_url:
        default: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
        required: false
    - script_url: 'http://vmdocker.hcm.demo.local:36980/job/AOS-repo/ws/deploy_war.sh'
    - parameters:
        required: false
  workflow:
    - is_artifact_given:
        do:
          io.cloudslang.base.strings.string_equals:
            - first_string: '${articfact_url}'
            - second_string: ''
        publish:
          - artifact_url: '${first_string}'
        navigate:
          - SUCCESS: copy_script
          - FAILURE: copy_artifact
    - delete_file:
        do:
          Integrations.demo.aos.tools.delete_file:
            - filename: '${script_name}'
        publish: []
        navigate:
          - SUCCESS: is_true
          - FAILURE: on_failure
    - copy_artifact:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${artifact_url}'
        publish:
          - artifact_url: '${filename}'
        navigate:
          - FAILURE: on_failure
          - SUCCESS: copy_script
    - copy_script:
        do:
          Integrations.demo.aos.sub_flows.remote_copy:
            - url: '${articfact_url}'
            - script_name: '${artifact_url}'
        publish:
          - script_name
        navigate:
          - FAILURE: on_failure
          - SUCCESS: execute_script
    - is_true:
        do:
          io.cloudslang.base.utils.is_true:
            - bool_value: "${str(command_return_code == '0')}"
        navigate:
          - 'TRUE': SUCCESS
          - 'FALSE': FAILURE
    - execute_script:
        do:
          io.cloudslang.base.ssh.ssh_command:
            - host: '${host}'
            - command: "${'cd '+get_sp('script_location')+' && chmod 755 '+script_name+' && sh '+script_name+' '+get('artifact_name', '')+' '+get('parameters', '')+' > '+script_name+'.log'}"
            - username: '${username}'
            - password:
                value: '${password}'
                sensitive: true
        publish:
          - command_return_code
        navigate:
          - SUCCESS: delete_file
          - FAILURE: delete_file
  outputs:
    - flow_output_0
  results:
    - FAILURE
    - SUCCESS
extensions:
  graph:
    steps:
      is_artifact_given:
        x: 417
        y: 51
      delete_file:
        x: 462
        y: 345
      copy_artifact:
        x: 276
        y: 194
      copy_script:
        x: 466
        y: 194
      is_true:
        x: 649
        y: 341
        navigate:
          60763865-76e8-3c67-1cd0-b9019d06a804:
            targetId: 18826622-75f3-2f7d-0db4-0a39a24767b4
            port: 'TRUE'
          813290f3-8d03-aa1d-ed67-af2e190c0a3a:
            targetId: f99b41c2-07a4-917b-62e2-73aaff6cd1cd
            port: 'FALSE'
      execute_script:
        x: 271
        y: 358
    results:
      FAILURE:
        f99b41c2-07a4-917b-62e2-73aaff6cd1cd:
          x: 786
          y: 460
      SUCCESS:
        18826622-75f3-2f7d-0db4-0a39a24767b4:
          x: 775
          y: 223
