pipeline {
    agent any

    stages {
        stage('Build') {
            steps {
                sh 'make build'
            }
        }
        stage('Push') {
            when {
                branch 'master'
            }
            steps {
                sh 'make push'
            }
        }
    }
}
