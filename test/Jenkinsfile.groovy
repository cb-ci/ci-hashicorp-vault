// Uses Declarative syntax to run commands inside a container.
pipeline {
    agent {
        kubernetes {
            yaml '''
            apiVersion: v1
            kind: Pod
            spec:
              containers:
              - name: shell
                image: ubuntu
                command:
                - sleep
                args:
                - infinity
                securityContext:
                  # ubuntu runs as root by default, it is recommended or even mandatory in some environments (such as pod security admission "restricted") to run as a non-root user.
                  runAsUser: 1000
            '''
            defaultContainer 'shell'
            retries 2
        }
    }
    stages {
        stage('Main') {
            steps {
                withCredentials([usernamePassword(credentialsId: 'vault-cloudbees-login', passwordVariable: 'pw', usernameVariable: 'user')]) {
                    echo "$user"
                    echo "$pw"
                }
                withCredentials([usernamePassword(credentialsId: 'vault-kv2-cloudbees-login', passwordVariable: 'pw', usernameVariable: 'user')]) {
                    echo "$user"
                    echo "$pw"
                }
            }
        }
    }
}
