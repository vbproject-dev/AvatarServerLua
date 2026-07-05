local ArrayList = {}
ArrayList.__index = ArrayList

function ArrayList.new()
    return setmetatable({ _data = {}, _size = 0 }, ArrayList)
end

function ArrayList:add(value)
    self._size = self._size + 1
    self._data[self._size] = value
end

function ArrayList:get(index)
    assert(index >= 1 and index <= self._size, "Index out of bounds")
    return self._data[index]
end

function ArrayList:set(index, value)
    assert(index >= 1 and index <= self._size, "Index out of bounds")
    self._data[index] = value
end

function ArrayList:remove(index)
    assert(index >= 1 and index <= self._size, "Index out of bounds")
    table.remove(self._data, index)
    self._size = self._size - 1
end

function ArrayList:size()
    return self._size
end

function ArrayList:contains(value)
    for i = 1, self._size do
        if self._data[i] == value then return true end
    end
    return false
end

function ArrayList:indexOf(value)
    for i = 1, self._size do
        if self._data[i] == value then return i end
    end
    return -1
end

function ArrayList:sort(comparator)
    table.sort(self._data, comparator)
end

function ArrayList:clear()
    self._data = {}
    self._size = 0
end

function ArrayList:toTable()
    local t = {}
    for i = 1, self._size do t[i] = self._data[i] end
    return t
end

return ArrayList
