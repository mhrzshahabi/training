package com.nicico.training.iservice;


import com.nicico.training.model.PersonnelCoursePassedOrNotPaseedNAReportView;

import java.util.List;

public interface IPersonnelCoursePassedOrNotPaseedNAReportViewService {

List<PersonnelCoursePassedOrNotPaseedNAReportView> getAll();
List<PersonnelCoursePassedOrNotPaseedNAReportView> getPassedOrUnPassed();


}
