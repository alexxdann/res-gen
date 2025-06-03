
# Resource generator for Godot 4

Godot editor generation tool. For now it is pretty simple and generates only scene with script for selected type.

Created on Godot 4.4

1) New item in context menu

   ![image](https://github.com/user-attachments/assets/fbf03d85-a02f-440f-b9ff-b75f32b96da0)

2) Open confirmation dialog

  ![image](https://github.com/user-attachments/assets/6f1ea90c-1f4a-412f-a680-c7b10a0e84e3)

4) Select type and name.
   
   When dropdown is opened you can type and automatically scroll to the desired type (built in godot option button behaviour, it searchs only beginning of words and will not find substring in type).
   
   Name could be snake case, pascal case or could have spaces, but in the end it will transforms anyway (file names/path to snake case and node name to pascal case).

  ![image](https://github.com/user-attachments/assets/8674be3d-5d88-4281-85ae-c16f10859c77)

5) Creates new directory with files

  ![image](https://github.com/user-attachments/assets/03317a32-3b1f-4e53-902a-fd414d8244e3)


## Demo
![res-gen-upd](https://github.com/user-attachments/assets/feb0aed0-8862-4cba-af8f-77402436e122)

