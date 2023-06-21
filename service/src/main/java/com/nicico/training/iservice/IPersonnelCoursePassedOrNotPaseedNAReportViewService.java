package com.nicico.training.iservice;


import com.nicico.training.model.PersonnelCoursePassedOrNotPaseedNAReportView;

import java.util.List;

public interface IPersonnelCoursePassedOrNotPaseedNAReportViewService {

List<PersonnelCoursePassedOrNotPaseedNAReportView> getAll();
List<PersonnelCoursePassedOrNotPaseedNAReportView> getPassedOrUnPassed(List<Long> catIds, String isPassed, List<String> complexList , List<String> assistantList ,  List<String> affairList);


}
