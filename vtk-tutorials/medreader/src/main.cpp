#include <iostream>
#include <vtkMEDReader.h>
#include <vtkNew.h>
int main(int argc, char* argv[]) {
    std::cout << "Test medreader!" << std::endl;
    vtkNew<vtkMEDReader>reader;
    reader->SetFileName("/home/helen/Downloads/10.0.4.128/202412271722/result.med");
    reader->Update();
}
