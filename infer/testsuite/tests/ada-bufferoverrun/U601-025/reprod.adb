with Ada.Containers;
with Ada.Containers.Doubly_Linked_Lists;

package body Reprod
is

   --  This test strictly speaking makes no sense, but given how the Ada
   --  frontend works, it exercises the problem and there is currently no other
   --  way how to exercise the problem using Ada frontend. The comments in
   --  the source code show how the problem should be correctly reproduced
   --  when allocations would be implemented.
   --
   --  The problem: if we have an allocation in loop, a single (allocsite)
   --  location is created to represent all possible allocations at that program
   --  point. This location has to be weakly updated.
   procedure Test is
      type Arr is array (Positive range 1 .. 10) of Integer;
      type Arr_Ptr is access all Arr;
      Prev : Arr_Ptr;
      Now : Arr_Ptr;
   begin
      loop
         if Prev /= null then
            Prev (1) := 41;
         end if;
         declare
            --  Implicit malloc, returns the same allocsite for all loop iterations.
            --  This allocsite cannot be strongly updated with bot.
            --  Prev is pointing to this allocsite and if it is strongly updated
            --  with bot, the previous value 41 is lost.
            X : aliased Arr;
         begin
            X (1) := 42;
            Now := X'Access;  -- Now := new Integer (42);  -- the same allocsite is returned for all loop iterations. It has to be weakly updated.
            if Prev /= null then
               pragma Assert (Prev (1) = 41);  -- @assertion:PASS  -- pragma Assert (Prev.all = 41);  -- the allocsite pointed by Prev must have both values 41 and 42
            end if;
         end;
         Prev := Now;
      end loop;
   end Test;

end Reprod;
