package com.nicico.training.service;

import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.TclassDTO;
import com.nicico.training.iservice.IPersonnelInformationService;
import com.nicico.training.model.Course;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Skill;
import com.nicico.training.model.Tclass;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.TclassDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class PersonnelInformationService implements IPersonnelInformationService {

    private final CourseDAO courseDAO;
    private final TclassDAO tclassDAO;
    private final ModelMapper modelMapper;

    @Transactional
    @Override
    public CourseDTO.CourseDetailInfo findCourseById(Long courseId) {
        Course course = courseDAO.findCourseByIdEquals(courseId);
        CourseDTO.CourseDetailInfo courseDetailInfo = modelMapper.map(course, CourseDTO.CourseDetailInfo.class);

        StringBuilder mainObjective = new StringBuilder();
        int counter = 1;
        for (Skill skill : course.getSkillMainObjectiveSet()) {
            mainObjective.append(counter++).append("- ").append(skill.getTitleFa()).append(" - ").append(skill.getCode()).append("\n");
        }

        StringBuilder goals = new StringBuilder();
        counter = 1;
        for (Goal goal : course.getGoalSet()) {
            goals.append(counter++).append("- ").append(goal.getTitleFa()).append("\n");
        }

        StringBuilder preCourses = new StringBuilder();
        counter = 1;
        for (Course preCourse : course.getPreCourseList()) {
            preCourses.append(counter++).append("- ").append(preCourse.getTitleFa()).append(" - ").append(preCourse.getCode()).append("\n");
        }

        courseDetailInfo.setMainObjective(mainObjective.toString());
        courseDetailInfo.setGoals(goals.toString());
        courseDetailInfo.setPreCourses(preCourses.toString());

        return courseDetailInfo;
    }

    @Transactional
    @Override
    public TclassDTO.ClassDetailInfo findClassById(Long classId) {
        Tclass tclass = tclassDAO.findTclassByIdEquals(classId);
        TclassDTO.ClassDetailInfo classDetailInfo = modelMapper.map(tclass, TclassDTO.ClassDetailInfo.class);

        classDetailInfo.setClassSessionTimes(
                (classDetailInfo.getFirst() != null && classDetailInfo.getFirst() ? "8-10 , " : "") +
                        (classDetailInfo.getSecond() != null && classDetailInfo.getSecond() ? "10-12 , " : "") +
                        (classDetailInfo.getThird() != null && classDetailInfo.getThird() ? "14-16 , " : "") +
                        (classDetailInfo.getFourth() != null && classDetailInfo.getFourth() ? "12-14" : "") +
                        (classDetailInfo.getFifth() != null && classDetailInfo.getFifth() ? "16-18" : ""));

        classDetailInfo.setClassDays(
                (classDetailInfo.getSaturday() != null && classDetailInfo.getSaturday() ? "شنبه , " : "") +
                        (classDetailInfo.getSunday() != null && classDetailInfo.getSunday() ? "یکشنبه , " : "") +
                        (classDetailInfo.getMonday() != null && classDetailInfo.getMonday() ? "دوشنبه , " : "") +
                        (classDetailInfo.getTuesday() != null && classDetailInfo.getTuesday() ? "سه شنبه , " : "") +
                        (classDetailInfo.getWednesday() != null && classDetailInfo.getWednesday() ? "چهارشنبه , " : "") +
                        (classDetailInfo.getThursday() != null && classDetailInfo.getThursday() ? "پنجشنبه , " : "") +
                        (classDetailInfo.getFriday() != null && classDetailInfo.getFriday() ? "جمعه " : ""));

        if (classDetailInfo.getClassSessionTimes().length() > 0)
            classDetailInfo.setClassSessionTimes(classDetailInfo.getClassSessionTimes().substring(0, classDetailInfo.getClassSessionTimes().length() - 2));

        if (classDetailInfo.getClassDays().length() > 0)
            classDetailInfo.setClassDays(classDetailInfo.getClassDays().substring(0, classDetailInfo.getClassDays().length() - 2));


        return classDetailInfo;
    }

    @Transactional
    @Override
    public List<TclassDTO.TclassHistory> findClassesByCourseId(Long courseId)
    {
        return  modelMapper.map(tclassDAO.getTclassByCourseIdEquals(courseId), new TypeToken<List<TclassDTO.TclassHistory>>(){}.getType());
    }

}
