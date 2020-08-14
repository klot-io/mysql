pipeline {
    agent any

    stages {
        stage('build') {
            steps {
                sh 'make build'
            }
        }
        stage('push') {
            when {
                branch 'master'
            }
            steps {
                sh 'make push'
            }
        }
    }
}
