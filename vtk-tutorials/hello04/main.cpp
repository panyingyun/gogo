#include <iostream>
#include <string>
#include <glog/logging.h>
#include <gflags/gflags.h>

void init_glog(char *name)
{
  FLAGS_colorlogtostderr = true;
  FLAGS_colorlogtostdout = true;

  google::InitGoogleLogging(name);
  google::SetStderrLogging(google::INFO);
  google::InstallFailureSignalHandler();
  // google::SetLogDestination(google::INFO, "log/INFO_");
  // google::SetLogFilenameExtension("logExtension");
  // google::SetLogDestination(google::GLOG_INFO, "./demo.log.info");
  // google::SetLogDestination(google::GLOG_WARNING, "./demo.log.warning");
  // google::SetLogDestination(google::GLOG_ERROR, "./demo.log.error");
  // google::SetLogDestination(google::GLOG_FATAL, "./demo.log.fatal");
}

int main(int argc, char *argv[])
{
  // test glog
  init_glog(argv[0]);
  google::ParseCommandLineFlags(&argc, &argv, true); // 初始化 gflags
  LOG(INFO) << "argv[0]= " << argv[0];
  LOG(INFO) << "This is a info log!";
  LOG(WARNING) << "This is a warning log!";
  LOG(ERROR) << "This is a error log!";

  LOG(ERROR) << "This is a error log!";
  LOG(ERROR) << "This is a error log!";
  LOG(ERROR) << "This is a error log!";
  return 0;
}