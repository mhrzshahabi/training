package com.nicico.training.service;

import com.nicico.copper.core.domain.criteria.SearchUtil;
import com.nicico.copper.core.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.*;
import com.nicico.training.iservice.ICourseService;
import com.nicico.training.model.*;
import com.nicico.training.model.enums.EnumsConverter;
import com.nicico.training.repository.*;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.sql.Array;
import java.util.*;

@Service
@RequiredArgsConstructor
public class CourseService implements ICourseService {

    private final ModelMapper modelMapper;
    private final GoalDAO goalDAO;
    private final SkillDAO skillDAO;
    private final CourseDAO courseDAO;
    private final CompetenceDAO competenceDAO;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ELevelTypeConverter eLevelTypeConverter = new EnumsConverter.ELevelTypeConverter();
    private final EnumsConverter.ERunTypeConverter eRunTypeConverter = new EnumsConverter.ERunTypeConverter();
    private final EnumsConverter.ETheoTypeConverter eTheoTypeConverter = new EnumsConverter.ETheoTypeConverter();


    @Transactional(readOnly = true)
    @Override
    public CourseDTO.Info get(Long id) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.EquipmentNotFound));
        return modelMapper.map(course, CourseDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> list() {
        final List<Course> cAll = courseDAO.findAll();
        return modelMapper.map(cAll, new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }


    @Transactional
    @Override
    public CourseDTO.Info create(CourseDTO.Create request) {
        Course course = modelMapper.map(request, Course.class);

        course.setELevelType(eLevelTypeConverter.convertToEntityAttribute(request.getELevelTypeId()));
        course.setERunType(eRunTypeConverter.convertToEntityAttribute(request.getERunTypeId()));
        course.setETheoType(eTheoTypeConverter.convertToEntityAttribute(request.getETheoTypeId()));
        course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        return modelMapper.map(courseDAO.saveAndFlush(course), CourseDTO.Info.class);

    }

    @Transactional
    @Override
    public CourseDTO.Info update(Long id, CourseDTO.Update request) {
        final Optional<Course> optionalCourse = courseDAO.findById(id);
        final Course currentCourse = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));



        Course course = new Course();
        modelMapper.map(currentCourse, course);
        modelMapper.map(request, course);
        course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        course.setETheoType(eTheoTypeConverter.convertToEntityAttribute(request.getETheoTypeId()));
        course.setERunType(eRunTypeConverter.convertToEntityAttribute(request.getERunTypeId()));
        course.setELevelType(eLevelTypeConverter.convertToEntityAttribute(request.getELevelTypeId()));
        return modelMapper.map(courseDAO.saveAndFlush(course), CourseDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {

      courseDAO.deleteById(id);
    }

    @Transactional
    @Override
    public void delete(CourseDTO.Delete request) {
        final List<Course> cAllById = courseDAO.findAllById(request.getIds());
        courseDAO.deleteAll(cAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CourseDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, CourseDTO.Info.class));
    }

    //-------jafari--------
    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> searchDetails(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<CourseDTO.GoalsWithSyllabus> search = SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, CourseDTO.GoalsWithSyllabus.class));
        return search;
    }
    //-------jafari--------


    @Transactional
    @Override
    public List<GoalDTO.Info> getgoal(Long courseId) {
        final Optional<Course> ssById = courseDAO.findById(courseId);
        final Course course = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        List<GoalDTO.Info> goalInfo = new ArrayList<>();
        Optional.ofNullable(course.getGoalSet())
                .ifPresent(goals ->
                        goals.forEach(goal ->
                                goalInfo.add(modelMapper.map(goal, GoalDTO.Info.class))
                        ));
        return goalInfo;
    }

    @Transactional
    @Override
    public List<GoalDTO.Info> getGoalWithOut(Long courseId) {
        Course one = courseDAO.getOne(courseId);
        List<Goal> goalSet = one.getGoalSet();
        List<Goal> all = goalDAO.findAll();
        all.removeAll(goalSet);
        List<GoalDTO.Info> goalInfo = new ArrayList<>();
        Optional.ofNullable(all)
                .ifPresent(goals ->
                        goals.forEach(goal ->
                                goalInfo.add(modelMapper.map(goal, GoalDTO.Info.class))
                        ));
        return goalInfo;
    }

    @Transactional
    @Override
    public void getCourseIdvGoalsId(Long courseId, List<Long> goalIdList) {
        Course one = courseDAO.getOne(courseId);
        List<Goal> goalSet = one.getGoalSet();
        for (Long aLong : goalIdList) {
            final Optional<Goal> ById = goalDAO.findById(aLong);
            final Goal goal = ById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
            goalSet.add(goal);
        }
        one.setGoalSet(goalSet);
    }

    @Transactional
    @Override
    public void removeCourseSGoal(Long courseId, List<Long> goalIdList) {
        Course one = courseDAO.getOne(courseId);
        List<Goal> goalSet = one.getGoalSet();
        for (Long aLong : goalIdList) {
            final Optional<Goal> ById = goalDAO.findById(aLong);
            final Goal goal = ById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
            goalSet.remove(goal);
        }
        one.setGoalSet(goalSet);
    }

    @Transactional
    @Override
    public List<SkillDTO.Info> getSkill(Long courseId) {
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        List<SkillDTO.Info> skillInfo = new ArrayList<>();
        Optional.ofNullable(skillSet)
                .ifPresent(skills ->
                        skills.forEach(skill ->
                                skillInfo.add(modelMapper.map(skill, SkillDTO.Info.class))
                        ));
        return skillInfo;
    }

    @Transactional
    @Override
    public List<JobDTO.Info> getJob(Long courseId) {
        Set<Job> jobSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            Set<Competence> competenceSet = skill.getCompetenceSet();
            for (Competence competence : competenceSet) {
                Set<JobCompetence> jobCompetenceSet = competence.getJobCompetenceSet();
                for (JobCompetence jobCompetence : jobCompetenceSet) {
                    Job job = jobCompetence.getJob();
                    jobSet.add(job);
                }
            }
        }
        List<JobDTO.Info> jobInfo = new ArrayList<>();
        Optional.ofNullable(jobSet)
                .ifPresent(jobs ->
                        jobs.forEach(job ->
                                jobInfo.add(modelMapper.map(job, JobDTO.Info.class))
                        ));
        return jobInfo;
    }


    @Transactional
    @Override
    public String getMaxCourseCode(String str) {
        List<Course> courseList = courseDAO.findByCodeStartingWith(str);
        int max = 0;
        if (courseList.size() == 0)
            return "0";
        for (Course course : courseList) {
            if (max < Integer.parseInt(course.getCode().substring(6, 10)))

                max = Integer.parseInt(course.getCode().substring(6, 10));

        }
        return String.valueOf(max);
    }

    @Transactional
    @Override
    public List<CompetenceDTO.Info> getCompetenceQuery(Long courseId) {
        List<CompetenceDTO.Info> compeInfoList = new ArrayList<>();
        List<Competence> competenceList = competenceDAO.findCompetenceByCourseId(courseId);
        Optional.ofNullable(competenceList)
             .ifPresent(competence ->
                       competence.forEach(comp ->
                       compeInfoList.add(modelMapper.map(comp, CompetenceDTO.Info.class))
                        ));
        return compeInfoList;
    }

    //-------------------------------
    @Transactional
    @Override
    public List<CompetenceDTO.Info> getCompetence(Long courseId) {
        List<CompetenceDTO.Info> compeInfoList = new ArrayList<>();
        Set<Competence> competenceSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet)
            competenceSet = skill.getCompetenceSet();
        Optional.ofNullable(competenceSet)
                .ifPresent(competence ->
                        competence.forEach(comp ->
                                compeInfoList.add(modelMapper.map(comp, CompetenceDTO.Info.class))
                        ));
        return compeInfoList;
    }

    @Transactional
    @Override
    public boolean  checkForDelete(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        Set<Skill> skillSet = course.getSkillSet();
        Set<Tclass> tclasses = course.getTclassSet();
        List<Goal> goalSet = course.getGoalSet();
        return (((skillSet != null &&   skillSet.size() > 0) || (tclasses != null && tclasses.size() > 0 )) ? false :true);
    }

    @Transactional
    @Override
    public void deletGoal(Long id)
    {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        course.getGoalSet().clear();

    }
}
