pipeline {
    environment {
        image_name = "cblock_image_${env.BRANCH_NAME}:${BUILD_NUMBER}"
        // gitlab soulmachines credentials
        registryCredential = 'cogarch-docker-registry'
        containerName = "cblock_container_${env.BRANCH_NAME}_${BUILD_NUMBER}"
        dockerImage = ''
    }
    post {
        failure {
            script {
                if (env.BRANCH_NAME == 'master') {
                    slackSend color: 'danger', channel: '#cogarch-tests', message: "${env.JOB_NAME} #${env.BUILD_NUMBER} failure"
                }
            }
            updateGitlabCommitStatus name: 'build', state: 'failed'
            
        }
        unstable {
            script {
                if (env.BRANCH_NAME == 'master') {
                    slackSend color: 'warning', channel: '#cogarch-tests', message: "${env.JOB_NAME} #${env.BUILD_NUMBER} test failure"
                }                
            }
            updateGitlabCommitStatus name: 'build', state: 'failed'
        }
        success {
            script {
                if (env.BRANCH_NAME == 'master') {
                    slackSend color: 'good', channel: '#cogarch-tests', message: "${env.JOB_NAME} #${env.BUILD_NUMBER} successful"
                }
            }
            updateGitlabCommitStatus name: 'build', state: 'success'
        }
        always {
            sh """
            docker stop ${image_name} 2> /dev/null || true
            docker rm ${containerName} 2> /dev/null || true 
            docker rmi -f ${image_name} 2> /dev/null || true
            """
        }
    }
    options {
        gitLabConnection('jenkins-gitlab-integration-test')
        buildDiscarder(logRotator(numToKeepStr: '10')) 
    }
    triggers {
        upstream(upstreamProjects: env.BRANCH_NAME == 'master'? 'sml-base-container': '', threshold: hudson.model.Result.UNSTABLE)
    }
    // TODO: Remove linux label once docker works on mac nodes
    agent { node { label 'linux && docker' } } 
    stages {
        stage('Building image') {
            steps {
                script {
                    // Pass registry creds to build process so we can get the base image
                    docker.withRegistry('https://gitlab.soulmachines.com:5005', registryCredential ) {
                        // Pass the svn creds to the build process
                        dockerImage = docker.build(image_name, '--pull --rm -f Dockerfile .')                                                                                 
                    }
                    
                }
            }
        }
        stage('Building and executing test suite')
        {
            steps {
                script {
                    // Can't use the Jenkins docker plugin because it doesn't let us run in non-daemon mode
                    sh "docker run --mount source=bl_third_party,target=/usr/src/third_party --name ${containerName} ${image_name} /usr/src/app/source/build_and_test.sh"
                }
            }
        }
        stage('Recording test results')
        {
            steps {
                    sh "docker cp ${containerName}:/usr/src/app/source/gtest-xml ."
                    junit 'gtest-xml/*.xml'
            }
        }
    }  
}