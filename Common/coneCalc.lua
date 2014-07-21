--[[ "Cone" helper
        by llama
--]]
 
function areClockwise(testv1,testv2)
        return -testv1.x * testv2.y + testv1.y * testv2.x>0 --true if v1 is clockwise to v2
end
function sign(x)
        if x> 0 then return 1
        elseif x<0 then return -1
        end
end
function GetCone(radius,theta)
 
        --Build table of enemies in range
        n = 1
        v1,v2,v3 = 0,0,0
        largeN,largeV1,largeV2 = 0,0,0
        theta1,theta2,smallBisect = 0,0,0
        coneTargetsTable = {}
       
        for i = 1, objManager:GetMaxHeroes(), 1 do
        hero = objManager:GetHero(i)
        if ValidTarget(hero) and hero.team == TEAM_ENEMY and GetDistance(hero) <= radius then -- and inRadius(hero,radius*radius) then
                        coneTargetsTable[n] = hero
                        n=n+1
                end
        end
 
        if #coneTargetsTable>=2 then -- true if calculation is needed
        --Determine if angle between vectors are < given theta
                for i=1, #coneTargetsTable,1 do
                        for j=1,#coneTargetsTable, 1 do
                                if i~=j then
                                        --Position vector from player to 2 different targets.
                                        v1 = Vector(coneTargetsTable[i].x-myHero.x , coneTargetsTable[i].z-myHero.z)
                                        v2 = Vector(coneTargetsTable[j].x-myHero.x , coneTargetsTable[j].z-myHero.z)
                                        thetav1 = sign(v1.y)*90-math.deg(math.atan(v1.x/v1.y))
                                        thetav2 = sign(v2.y)*90-math.deg(math.atan(v2.x/v2.y))
                                        thetaBetween = thetav2-thetav1                 
 
                                        if (thetaBetween) <= theta and thetaBetween>0 then --true if targets are close enough together.
                                                if #coneTargetsTable == 2 then --only 2 targets, the result is found.
                                                        largeV1 = v1
                                                        largeV2 = v2
                                                else
                                                        --Determine # of vectors between v1 and v2                                                     
                                                        tempN = 0
                                                        for k=1, #coneTargetsTable,1 do
                                                                if k~=i and k~=j then
                                                                        --Build position vector of third target
                                                                        v3 = Vector(coneTargetsTable[k].x-myHero.x , coneTargetsTable[k].z-myHero.z)
                                                                        --For v3 to be between v1 and v2
                                                                        --it must be clockwise to v1
                                                                        --and counter-clockwise to v2
                                                                        if areClockwise(v3,v1) and not areClockwise(v3,v2) then
                                                                                tempN = tempN+1
                                                                        end
                                                                end
                                                        end
                                                        if tempN > largeN then
                                                        --store the largest number of contained enemies
                                                        --and the bounding position vectors
                                                                largeN = tempN
                                                                largeV1 = v1
                                                                largeV2 = v2
                                                        end
                                                end
                                        end
                                end
                        end
                end
        elseif #coneTargetsTable==1 then
                return coneTargetsTable[1]
        end
       
        if largeV1 == 0 or largeV2 == 0 then
        --No targets or one target was found.
                return nil
        else
        --small-Bisect the two vectors that encompass the most vectors.
                if largeV1.y == 0 then
                        theta1 = 0
                else
                        theta1 = sign(largeV1.y)*90-math.deg(math.atan(largeV1.x/largeV1.y))
                end
                if largeV2.y == 0 then
                        theta2 = 0
                else
                        theta2 = sign(largeV2.y)*90-math.deg(math.atan(largeV2.x/largeV2.y))
                end
 
                smallBisect = math.rad((theta1 + theta2) / 2)
                vResult = {}
                vResult.x = radius*math.cos(smallBisect)+myHero.x
                vResult.y = myHero.y
                vResult.z = radius*math.sin(smallBisect)+myHero.z
               
                return vResult
        end
end