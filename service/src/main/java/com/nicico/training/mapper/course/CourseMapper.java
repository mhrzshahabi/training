package com.nicico.training.mapper.course;

import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.ElsCourseDTO;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.model.Course;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Syllabus;
import com.nicico.training.repository.CourseDAO;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Set;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.WARN)
public abstract class CourseMapper {
    @Autowired
    protected CourseDAO courseDAO;
    @Autowired
    protected IGoalService goalService;
    @Autowired
    protected ICourseService courseService;
    @Transactional
    public ElsCourseDTO toCourseDTO(Course course){
        ElsCourseDTO elsCourseDTO=new ElsCourseDTO();

        List<String> syllablesList=new ArrayList<>();
       List<Long> goalsIds=courseDAO.findAllGoalId(course.getId());
       if(goalsIds!=null && goalsIds.size()>0){
           goalsIds.stream().forEach(goalId->{
               Goal goal=goalService.getById(goalId);
             Set<Syllabus> syllabusSet=goal.getSyllabusSet();
               if(syllabusSet !=null && syllabusSet.stream().count()>0L) {
                   syllabusSet.stream().forEach(syllabus -> {
                       syllablesList.add(syllabus.getTitleFa());
                   });
               }
           });
       }


             List<Long>  preCourseIds=  courseDAO.findAllPreCourseId(course.getId());
             List<String> preCourseList=new ArrayList<>();
       if(preCourseIds!=null && preCourseIds.size()>0){
           preCourseIds.stream().forEach(preCourse ->{
                 Course c =courseService.getCourse(preCourse);
                 preCourseList.add(c.getTitleFa());
           } );
       }
       elsCourseDTO.setDuration(course.getTheoryDuration().toString());
       elsCourseDTO.setPreCourseTitles(preCourseList);
       elsCourseDTO.setCourseSyllabusList(syllablesList);
       elsCourseDTO.setStatus(200);
       return elsCourseDTO;
    }

    @Mapping(source = "postCode", target = "code")
    public abstract CourseDTO.TupleInfo toPostCodeDTO(String postCode);
    public abstract List<CourseDTO.TupleInfo> toPostCodeDTOList(List<String> postCodes);
}
