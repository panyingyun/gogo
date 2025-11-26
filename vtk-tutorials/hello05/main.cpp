#include <iostream>
#include <string>
#include <glog/logging.h>
#include <gflags/gflags.h>
#include <vtkCubeSource.h>
#include <vtkPolyData.h>
#include <vtkSmartPointer.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkCamera.h>
#include <vtkRenderWindow.h>
#include <vtkRenderer.h>
#include <vtkRenderWindowInteractor.h>
#include <vtkOBJExporter.h>

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

int vtk_cube()
{

  LOG(INFO) << "Create vtkCubeSource!";
  vtkNew<vtkCubeSource> cube;

  // mapper
  vtkNew<vtkPolyDataMapper> cubeMapper;
  cubeMapper->SetInputConnection(cube->GetOutputPort());

  // actor
  vtkNew<vtkActor> cubeActor;
  cubeActor->SetMapper(cubeMapper);

  // camera
  vtkNew<vtkCamera> camera;
  camera->SetPosition(1, 1, 1);   // 设置相机位置
  camera->SetFocalPoint(0, 0, 0); // 设置相机焦点

  // renderer
  vtkNew<vtkRenderer> renderer;
  renderer->AddActor(cubeActor);
  renderer->SetActiveCamera(camera);
  renderer->ResetCamera();

  // RenderWindow
  vtkNew<vtkRenderWindow> renWin;
  renWin->OffScreenRenderingOn();
  renWin->AddRenderer(renderer);
  renWin->SetSize(600, 600); // 设置window大小

  // // RenderWindowInteractor
  // vtkNew<vtkRenderWindowInteractor> iren;
  // iren->SetRenderWindow(renWin);

  // 数据交互
  renWin->Render();
  // iren->Start();

  // 导出文件
  LOG(INFO) << "Create vtkOBJExporter and export Cube to obj file!";
  vtkSmartPointer<vtkOBJExporter> porter = vtkSmartPointer<vtkOBJExporter>::New();
  porter->SetFilePrefix("box");
  porter->SetInput(renWin);
  porter->Write();
  return 0;
}

int main(int argc, char *argv[])
{
  // test glog
  init_glog(argv[0]);
  google::ParseCommandLineFlags(&argc, &argv, true); // 初始化 gflags
  LOG(INFO) << "argv[0]= " << argv[0];
  LOG(INFO) << "This is a vtk cube app!";
  // LOG(WARNING) << "This is a warning log!";
  // LOG(ERROR) << "This is a error log!";

  // LOG(ERROR) << "This is a error log!";
  // LOG(ERROR) << "This is a error log!";
  // LOG(ERROR) << "This is a error log!";
  vtk_cube();
  return 0;
}