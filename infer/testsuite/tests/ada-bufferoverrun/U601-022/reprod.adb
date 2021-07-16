with Ada.Containers;
with Ada.Containers.Doubly_Linked_Lists;

package body Reprod
is

   procedure A is
      type Arr is array (Positive range <>) of Integer;
      A : Arr (1 .. 10);
      B : Arr (1 .. 10);

      function Ret_Array return Arr is
         C : Arr (1 .. 10);
      begin
         C (1) := 41;
         return C;
      end Ret_Array;
   begin
      A (1) := 40;
      B := Ret_Array;

      pragma Assert (A (1) = 40);  -- @assertion:PASS
   end A;

end Reprod;
