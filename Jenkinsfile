#!groovy
// Run docker build
properties([disableConcurrentBuilds()])

pipeline {
    agent { 
        label 'centos'
        }
    triggers { pollSCM('* * * * *') }
    options {
        buildDiscarder(logRotator(numToKeepStr: '10', artifactNumToKeepStr: '10'))
        timestamps()
    }
    stages {
        stage('Downloading git-repository') {
            steps {
                    git branch: 'master',
                    url: 'https://github.com/ArtemBelozerov/student-exam2'
					}
            }
		stage('Building app') {
            steps {
                sh """
                    python3 -m venv venv
                    . venv/bin/activate
                    pip install -e .
                    export FLASK_APP=js_example
                """
            }
        }
    
        stage('Testing app') {
            steps {
                sh """
                    . venv/bin/activate
                    pip install -e '.[test]'
                    coverage run -m pytest
                    coverage report
                    deactivate
                """
            }
        }
        stage("Login to dockerhub") {
            steps {
                echo " *** docker login ***"
                withCredentials([usernamePassword(credentialsId: 'dockerhub_belozerov', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
                    sh """
                    docker login -u $USERNAME -p $PASSWORD
                    """
                }
            }
        }
        stage("Creating docker image.") {
            steps {
                echo " *** start building image ***"
                	sh 'docker build -t belozerov/exam:flaskapp . '
            }
        }
        stage("Pushing image to dockerhub") {
            steps {
                echo " *** start pushing image ***"
                sh '''
                docker push belozerov/exam:flaskapp 
                '''
            }
        }
    }
}
