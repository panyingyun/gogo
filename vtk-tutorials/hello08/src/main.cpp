#include <vtkNew.h>
#include <vtkProperty.h>
#include <vtkPolyDataMapper.h>
#include <vtkActor.h>
#include <vtkCamera.h>
#include <vtkRenderer.h>
#include <vtkRenderWindow.h>
#include <vtkGraphicsFactory.h>
#include <vtkSphereSource.h>
#include <vtkNamedColors.h>
#include <vtkWindowToImageFilter.h>
#include <vtkPNGWriter.h>

int main()
{
    vtkNew<vtkNamedColors> colors;

    // Setup offscreen rendering
    // vtkNew<vtkGraphicsFactory> graphics_factory;
    // graphics_factory->SetOffScreenOnlyMode(1);
    // graphics_factory->SetUseMesaClasses(1);

    // Create a sphere
    vtkNew<vtkSphereSource> sphereSource;

    // Create a mapper and actor
    vtkNew<vtkPolyDataMapper> mapper;
    mapper->SetInputConnection(sphereSource->GetOutputPort());

    vtkNew<vtkActor> actor;
    actor->SetMapper(mapper);
    actor->GetProperty()->SetColor(colors->GetColor3d("White").GetData());

    // A renderer and render window
    vtkNew<vtkRenderer> renderer;
    vtkNew<vtkRenderWindow> renderWindow;
    renderWindow->SetOffScreenRendering(1);
    renderWindow->AddRenderer(renderer);

    // Add the actors to the scene
    renderer->AddActor(actor);
    renderer->SetBackground(colors->GetColor3d("SlateGray").GetData());

    renderWindow->Render();

    vtkNew<vtkWindowToImageFilter> windowToImageFilter;
    windowToImageFilter->SetInput(renderWindow);
    windowToImageFilter->Update();

    vtkNew<vtkPNGWriter> writer;
    writer->SetFileName("screenshot.png");
    writer->SetInputConnection(windowToImageFilter->GetOutputPort());
    writer->Write();

    return EXIT_SUCCESS;
}
