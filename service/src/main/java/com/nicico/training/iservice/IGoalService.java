package com.nicico.training.iservice;/* com.nicico.training.iservice
@Author:jafari-h
@Date:5/28/2019
@Time:3:39 PM
*/

import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.SyllabusDTO;

import java.util.List;

public interface IGoalService {

    GoalDTO.Info get(Long id);

    List<GoalDTO.Info> list();

    GoalDTO.Info create(GoalDTO.Create request, Long courseId);

    GoalDTO.Info update(Long id, GoalDTO.Update request);

    void delete(Long id);

    void delete(GoalDTO.Delete request);

    SearchDTO.SearchRs<GoalDTO.Info> search(SearchDTO.SearchRq request);

    //------------------------

    List<SyllabusDTO.Info> getSyllabusSet(Long goalId);
}
