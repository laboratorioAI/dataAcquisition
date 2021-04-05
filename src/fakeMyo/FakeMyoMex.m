classdef FakeMyoMex
    properties
        myoData
    end

    methods
        function myoObject = FakeMyoMex()
            myoObject.myoData = FakeMyoData();
        end
    end
end