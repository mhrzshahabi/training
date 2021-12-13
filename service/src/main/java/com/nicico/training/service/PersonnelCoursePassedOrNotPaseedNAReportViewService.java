package com.nicico.training.service;


import com.nicico.training.iservice.IPersonnelCoursePassedOrNotPaseedNAReportViewService;
import com.nicico.training.model.PersonnelCoursePassedOrNotPaseedNAReportView;
import com.nicico.training.repository.PersonnelCoursePassedNAReportViewDAO;
import com.nicico.training.repository.PersonnelCoursePassedOrNotPaseedNAReportViewDAO;
import lombok.RequiredArgsConstructor;

import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PersonnelCoursePassedOrNotPaseedNAReportViewService implements IPersonnelCoursePassedOrNotPaseedNAReportViewService {

    private final PersonnelCoursePassedOrNotPaseedNAReportViewDAO personnelCoursePassedOrNotPaseedNAReportViewDAO;

    @Override
    public List<PersonnelCoursePassedOrNotPaseedNAReportView> getAll() {
        return personnelCoursePassedOrNotPaseedNAReportViewDAO.findAll();
    }

    @Override
    public List<PersonnelCoursePassedOrNotPaseedNAReportView> getPassedOrUnPassed() {
        return personnelCoursePassedOrNotPaseedNAReportViewDAO.getPassedOrUnPassed("399");    }
}
