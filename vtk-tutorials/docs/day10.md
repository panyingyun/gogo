# Day10  如何用MeshIO解析med文件


- [Day10  如何用MeshIO解析med文件](#day10--如何用meshio解析med文件)
  - [简要介绍](#简要介绍)
  - [项目安装](#项目安装)
  - [基本使用](#基本使用)
  - [应用案例和最佳实践](#应用案例和最佳实践)
    - [案例一：网格格式转换](#案例一网格格式转换)
    - [案例二：网格数据读取](#案例二网格数据读取)
      - [示例一：读取med格式数据](#示例一读取med格式数据)
      - [示例二：读取vtk格式数据](#示例二读取vtk格式数据)
    - [案例三：数据解析](#案例三数据解析)
    - [案例四：创建一个网格](#案例四创建一个网格)
    - [案例五：读取多时间步的结果文件](#案例五读取多时间步的结果文件)
  - [其他注意事项（持续更新中）](#其他注意事项持续更新中)
    - [meshio中多种网格允许结点坐标为二维，但VTK不允许，如果写出VTK文件的结点为二维，meshio会提示并自动补足](#meshio中多种网格允许结点坐标为二维但vtk不允许如果写出vtk文件的结点为二维meshio会提示并自动补足)
    - [VTK格式不允许物理量名称中有空格，否则无法写出](#vtk格式不允许物理量名称中有空格否则无法写出)

## 简要介绍

meshio 是一个用于处理多种网格格式的 Python 库。它能够读取和写入多种网格文件格式，并且可以平滑地在这些格式之间进行转换。

同时，meshio也可以对部分物理场进行读取解析。本教材通过几个应用案例和最佳实践，展示meshio强大功能。

## 项目安装
首先，通过 pip 安装 meshio：

`pip install meshio `

## 基本使用
以下是一个简单的示例，展示如何读取和写入网格文件：

```
 import meshio
# 读取网格文件
mesh = meshio.read("input.vtk")
# 写入网格文件
mesh.write("output.vtu") 
```
## 应用案例和最佳实践
### 案例一：网格格式转换

假设你有一个 med 格式的网格文件 input.med，你想将其转换为 VTk 格式：

```
import meshio
 
mesh = meshio.read("input.med")
mesh.write("output.vtk")
```
### 案例二：网格数据读取
#### 示例一：读取med格式数据

```
import meshio


mesh = meshio.read("/home/helen/File/data/演示文件/meca.rmed",  file_format="med")

mesh

输出：
<meshio mesh object>
  Number of points: 45648
  Number of cells:
    hexahedron: 37040
    quad: 16720
  Point data: point_tags, displ___DEPL, stress__SIGM_NOEU, tempre__EPSI_NOEU
  Cell data: cell_tags
  Field data: med:nom
```
#### 示例二：读取vtk格式数据

```
import meshio


mesh = meshio.read("/home/helen/File/data/演示文件/mesh_4326.vtk",  file_format="vtk")

mesh

输出：
<meshio mesh object>
  Number of points: 385538
  Number of cells:
    triangle: 764785
  Point data: New_Mesh________________________, WATER_DEPTH_____M_______________, BOTTOM__________M_______________
```
### 案例三：数据解析
根据示例一输出，

```
<meshio mesh object>
  Number of points: 45648
  Number of cells:
    hexahedron: 37040
    quad: 16720
  Point data: point_tags, displ___DEPL, stress__SIGM_NOEU, tempre__EPSI_NOEU
  Cell data: cell_tags
  Field data: med:nom
```

已经读出meca.rmed这个文件中，包含点45648个，六面体单元37040个，四面体单元16270个。点数据4个point_tags, displ___DEPL, stress__SIGM_NOEU, tempre__EPSI_NOEU，单元数据一个cell_tags，场数据无。
为了解med网格里的节点坐标信息，输入以下代码

```
import meshio
mesh = meshio.read("/home/helen/File/data/演示文件/meca.rmed",  file_format="med")
points=mesh.points
points

输出：
array([[-18.46143894,  -1.1938477 ,   0.        ],
       [-18.49035722,  -0.59723515,   0.        ],
       [-17.41172575,  -0.56043456,   0.        ],
       ...,
       [  0.41124718,  13.10012984,  63.66548987],
       [  0.4100886 ,  13.06268568,  63.48211792],
       [  0.40893003,  13.02524152,  63.29874597]])
```

为了解med网格里的点数据信息。输入以下代码

```
import meshio
mesh = meshio.read("/home/helen/File/data/演示文件/meca.rmed",  file_format="med")
array=mesh.point_data
array

输出：
{'point_tags': array([0, 0, 0, ..., 0, 0, 0]),
 'displ___DEPL': array([[ 1.09648695e-35,  9.40395481e-35,  1.97127071e-35],
        [-8.47837742e-35,  1.31655367e-33,  1.06015429e-34],
        [ 4.32138085e-35, -1.12847458e-33,  1.19001242e-34],
        ...,
        [-9.09389359e-02,  1.28361901e+00,  6.42304821e-03],
        [-1.17459373e-01,  1.29021361e+00,  6.03655933e-03],
        [-1.44245771e-01,  1.29673261e+00,  5.64249806e-03]]),
 'stress__SIGM_NOEU': array([[-0.33254157, -4.33254157, -6.33254157],
        [-0.33254157, -4.33254157, -6.33254157],
        [-0.33254157, -4.33254157, -6.33254157],
        ...,
        [ 0.90720609, -3.81374557, -5.43783155],
        [ 0.82715721, -3.84460397, -5.57628364],
        [ 0.74599564, -3.87315579, -5.71652055]]),
 'tempre__EPSI_NOEU': array([20.49881235, 20.49881235, 20.49881235, ..., 20.00000002,
        19.99999995, 20.00000009])}
```

由上述输出可知。point_data属性是一个字典：键是字符串，值是数组。我们可以使用 通过键访问值[]。例如，取第二个特征模式：

```
import meshio
mesh = meshio.read("/home/helen/File/data/演示文件/meca.rmed",  file_format="med")
array=mesh.point_data
array["displ___DEPL"]

输出：
array([[ 1.09648695e-35,  9.40395481e-35,  1.97127071e-35],
       [-8.47837742e-35,  1.31655367e-33,  1.06015429e-34],
       [ 4.32138085e-35, -1.12847458e-33,  1.19001242e-34],
       ...,
       [-9.09389359e-02,  1.28361901e+00,  6.42304821e-03],
       [-1.17459373e-01,  1.29021361e+00,  6.03655933e-03],
       [-1.44245771e-01,  1.29673261e+00,  5.64249806e-03]])
```
每个标量值都是网格中节点的标量场的值。

### 案例四：创建一个网格
```
import meshio

# 定义结点坐标
points = [
    [0.0, 0.0],
    [1.0, 0.0],
    [0.0, 1.0],
    [1.0, 1.0],
    [2.0, 0.0],
    [2.0, 1.0],
]
#定义单元
cells = [
    ("triangle", [[0, 1, 2], [1, 3, 2]]),
    ("quad", [[1, 4, 5, 3]]),
]

#定义点数据
point_data={"T": [0.3, -1.2, 0.5, 0.7, 0.0, -3.0]},

#定义单元数据
cell_data={"a": [[0.1, 0.2], [0.4]]},

#组装mesh
mesh = meshio.Mesh(
    points,
    cells,
    point_data,
    cell_data,
)

#写出文件
mesh.write(
    "/home/helen/File/data/演示文件/foo.vtk", 
    file_format="vtk",
)

```
### 案例五：读取多时间步的结果文件

读取方法同案例一，多时间步的结果文件通过meshio解析出不同时刻的物理量值，以item号和时间为物理量名称后缀列出
```
import meshio
mesh = meshio.read("/home/helen/File/data/演示文件/meca.rmed",  file_format="med")
array=mesh.point_data
array["displ___DEPL"]
输出：
<meshio mesh object>
  Number of points: 385538
  Number of cells:
    triangle: 764785
  Point data: FREE SURFACE[0] - 0, 
              FREE SURFACE[1] - 60, 
              FREE SURFACE[2] - 120, 
              FREE SURFACE[3] - 180, 
              SCALAR FLOWRATE[0] - 0, 
              SCALAR FLOWRATE[1] - 60, 
              SCALAR FLOWRATE[2] - 120, 
              SCALAR FLOWRATE[3] - 180, 
              VILLAGE[0] - 0, 
              VILLAGE[1] - 60, 
              VILLAGE[2] - 120, 
              VILLAGE[3] - 180, 
              WATER DEPTH[0] - 0, 
              WATER DEPTH[1] - 60, 
              WATER DEPTH[2] - 120, 
              WATER DEPTH[3] - 180
  Field data: med:nom
  ```


## 其他注意事项（持续更新中）
### meshio中多种网格允许结点坐标为二维，但VTK不允许，如果写出VTK文件的结点为二维，meshio会提示并自动补足
```
Warning: VTK requires 3D points, but 2D points given. Appending 0 third component.
```

### VTK格式不允许物理量名称中有空格，否则无法写出
```
WriteError: VTK doesn't support spaces in field names ('FREE SURFACE[0] - 0')."
```
解决办法如下，重新创建一个网格，复制原网格中的信息，遍历修改物理量名称，删除空格后写出
```
import meshio
mesh = meshio.read("/home/helen/File/data/演示文件/result.med",  file_format="med")
array=mesh.point_data
array2={}
for key,value in array.items():
    key=key.replace(" ", "")
    array2[key]=value
mesh2 = meshio.Mesh(mesh.points,
                    mesh.cells,
                    point_data=array2)
mesh2.write("/home/helen/Downloads/foo.vtk",   file_format="vtk")
```
