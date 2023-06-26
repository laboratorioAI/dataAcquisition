classdef GestureSet
    %GestureSet is an enum class for defining either G5 or G11. In the case
    %of G11, the gestures are extended with G5. 

    %{
    Laboratorio de Inteligencia y Visión Artificial
    ESCUELA POLITÉCNICA NACIONAL
    Quito - Ecuador
    
    autor: ztjona!
    jonathan.a.zea@ieee.org
    Cuando escribí este código, solo dios y yo sabíamos como funcionaba.
    Ahora solo lo sabe dios.
    
    "I find that I don't understand things unless I try to program them."
    -Donald E. Knuth
   
    %}
%%
properties
      gestures
   end
   methods
      function s = GestureSet(gestures_list)
         s.gestures = gestures_list;
      end
   end

    %%
    enumeration
        G5  ({'waveIn', 'waveOut', 'fist', 'open', 'pinch'})
        G11 ({'up', 'down', 'forward', 'backward', 'left', 'right'})
    end
end
