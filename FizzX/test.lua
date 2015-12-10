list = {}
list[1] = ..
list[2] = ..
list.next = list2

map.list = list
if i > map.list.length then
   i = 0
   map.list = map.list.next
end