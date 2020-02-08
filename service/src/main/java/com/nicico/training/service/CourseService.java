package com.nicico.training.service;

import com.google.common.base.Joiner;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.SearchDTO;
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

import java.util.*;
import java.util.stream.Collectors;

import static java.lang.Math.round;

@Service
@RequiredArgsConstructor
public class CourseService implements ICourseService {

    private final ModelMapper modelMapper;
    private final GoalService goalService;
    private final GoalDAO goalDAO;
    private final EducationLevelDAO educationLevelDAO;
    private final TeacherDAO teacherDAO;
    private final SkillDAO skillDAO;
    private final SkillService skillService;
    private final CourseDAO courseDAO;
    private final CompetenceDAOOld competenceDAO;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ELevelTypeConverter eLevelTypeConverter = new EnumsConverter.ELevelTypeConverter();
    private final EnumsConverter.ERunTypeConverter eRunTypeConverter = new EnumsConverter.ERunTypeConverter();
    private final EnumsConverter.ETheoTypeConverter eTheoTypeConverter = new EnumsConverter.ETheoTypeConverter();


    @Transactional(readOnly = true)
    @Override
    public CourseDTO.Info get(Long id) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        return modelMapper.map(course, CourseDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> list() {
        final List<Course> cAll = courseDAO.findAll();
        return modelMapper.map(cAll, new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<CourseDTO.Info> preCourseList(Long id) {
        final List<CourseDTO.Info> listOut = new ArrayList<>();
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        String s = course.getPreCourse();
        if (s != null) {
            List<Long> x = Arrays.stream(s.split(","))
                    .map(Long::parseLong)
                    .collect(Collectors.toList());
            for (Long i : x) {
                Optional<Course> pById = courseDAO.findById(i);
                Course preCourse = pById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
                listOut.add(modelMapper.map(preCourse, CourseDTO.Info.class));
            }
        }
        return listOut;
    }

    @Transactional
    @Override
    public void setPreCourse(Long id, List<Long> preCourseListId) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        List<Course> allById = courseDAO.findAllById(preCourseListId);
        String s = Joiner.on(',').join(preCourseListId);
        course.setPreCourse(s);
        course.setPerCourseList(allById);
    }

    @Transactional
    @Override
    public void setEqualCourse(Long id, List<String> equalCourseList) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        String s1 = Joiner.on(',').join(equalCourseList);
        course.setEqualCourse(s1);
    }

    @Transactional(readOnly = true)
    @Override
    public List<Map> equalCourseList(Long id) {
        final List<Map> listOut = new ArrayList<>();
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        String s = course.getEqualCourse();
        if (s != null) {
            StringBuilder nameEQ1;
            List<String> myList = new ArrayList<>(Arrays.asList(s.split(",")));
            for (String idEQ1 : myList) {
                nameEQ1 = new StringBuilder();
                List<Long> x = Arrays.stream(idEQ1.split("_"))
                        .map(Long::parseLong)
                        .collect(Collectors.toList());
                for (Long j : x) {
                    Optional<Course> pById = courseDAO.findById(j);
                    if (pById.isPresent()) {
                        Course equalCourse = pById.get();
                        nameEQ1.append(" و ").append("'").append(equalCourse.getTitleFa()).append("(").append(equalCourse.getCode()).append(")").append("'");
                    }
                }
                nameEQ1 = new StringBuilder(nameEQ1.substring(3));
                Map<String, String> map = new HashMap<>();
                map.put("idEC", idEQ1);
                map.put("nameEC", nameEQ1.toString());
                listOut.add(map);
            }
        }
        return listOut;
    }


    @Transactional
    @Override
    public CourseDTO.Info create(CourseDTO.Create request) {
        Course course = modelMapper.map(request, Course.class);
        if (courseDAO.findByTitleFa(course.getTitleFa()).isEmpty()) {
            course.setELevelType(eLevelTypeConverter.convertToEntityAttribute(request.getELevelTypeId()));
            course.setERunType(eRunTypeConverter.convertToEntityAttribute(request.getERunTypeId()));
            course.setETheoType(eTheoTypeConverter.convertToEntityAttribute(request.getETheoTypeId()));
            course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
            Course course1 = courseDAO.save(course);
            Set<Skill> setSkill = new HashSet<>(skillDAO.findAllById(request.getMainObjectiveIds()));
            for (Skill skill : setSkill) {
                skill.setCourseId(course1.getId());
                skill.setCourseMainObjectiveId(course1.getId());
                skillDAO.saveAndFlush(skill);
            }
            return modelMapper.map(course1, CourseDTO.Info.class);
        } else
            return null;
    }

    @Transactional
    @Override
    public CourseDTO.Info update(Long id, CourseDTO.Update request) {
        final Optional<Course> optionalCourse = courseDAO.findById(id);
        final Course currentCourse = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        List<Long> preCourseListId = request.getPreCourseListId();
        List<Course> allById = courseDAO.findAllById(preCourseListId);
        currentCourse.setPerCourseList(allById);
        List<String> equalCourseListId = request.getEqualCourseListId();
        String s = Joiner.on(',').join(preCourseListId);
        String s1 = Joiner.on(',').join(equalCourseListId);
        Course course = new Course();
        modelMapper.map(currentCourse, course);
        modelMapper.map(request, course);
        course.setPreCourse(s);
        course.setEqualCourse(s1);
        course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
        course.setETheoType(eTheoTypeConverter.convertToEntityAttribute(request.getETheoTypeId()));
        course.setERunType(eRunTypeConverter.convertToEntityAttribute(request.getERunTypeId()));
        course.setELevelType(eLevelTypeConverter.convertToEntityAttribute(request.getELevelTypeId()));

        ////////////////////////////////////////////////////////////////////////
        List<EqualCourse> equalCourses = new ArrayList<>();
        for (String eqId : equalCourseListId) {
            EqualCourse equalCourse = new EqualCourse();
            equalCourse.setCourseId(course.getId());
            equalCourse.setEqualAndList(modelMapper.map(eqId.split("_"), new TypeToken<List<Long>>() {
            }.getType()));
            equalCourses.add(equalCourse);
        }
        course.setEqualCourses(equalCourses);
        ////////////////////////////////////////////////////////////////////////


        Course save = courseDAO.save(course);
        Set<Skill> savedSkills = save.getSkillMainObjectiveSet();
        Set<Skill> savingSkill = new HashSet<>(skillService.getAllByIds(request.getMainObjectiveIds()));
        if (!savedSkills.equals(savingSkill)) {
            if (savingSkill.containsAll(savedSkills)) {
                for (Skill skill : savingSkill) {
                    skill.setCourseMainObjectiveId(save.getId());
                    skill.setCourseId(save.getId());
                    skillDAO.save(skill);
                }
            } else {
                for (Skill savedSkill : savedSkills) {
                    savedSkill.setCourseMainObjectiveId(null);
                    skillDAO.save(savedSkill);
                }
                for (Skill skill : savingSkill) {
                    skill.setCourseMainObjectiveId(save.getId());
                    skill.setCourseId(save.getId());
                    skillDAO.save(skill);
                }
            }
        }
        return modelMapper.map(save, CourseDTO.Info.class);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        Optional<Course> byId = courseDAO.findById(id);
        Course course = byId.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        courseDAO.delete(course);
    }

    @Transactional
    @Override
    public void delete(CourseDTO.Delete request) {
        final List<Course> course = courseDAO.findAllById(request.getIds());
        courseDAO.deleteAll(course);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CourseDTO.Info> search(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<Course> search = SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, Course.class));
        SearchDTO.SearchRs<CourseDTO.Info> exitList = new SearchDTO.SearchRs<>();
        exitList.setTotalCount(search.getTotalCount());
        List<CourseDTO.Info> infoList = new ArrayList<>();
        List<Course> list = search.getList();
        for (Course course : list) {
            CourseDTO.Info map = modelMapper.map(course, CourseDTO.Info.class);
            infoList.add(map);
        }
        exitList.setList(infoList);
        return exitList;
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
            Set<NeedAssessment> needAssessments = skill.getNeedAssessments();
            for (NeedAssessment needAssessment : needAssessments) {
                Post post = needAssessment.getPost();
                Job job = post.getJob();
                jobSet.add(job);
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


    //      --------------------------------------- By f.ghazanfari - start ---------------------------------------
//                for (CompetenceOld competence : competenceSet) {
//                    Set<JobCompetence> jobCompetenceSet = competence.getJobCompetenceSet();
//                    for (JobCompetence jobCompetence : jobCompetenceSet) {
//                        JobOld job = jobCompetence.getJob();
//                        jobSet.add(job);
//                    }
//                }
    //      --------------------------------------- By f.ghazanfari - end ---------------------------------------

//            }
//            Set<CompetenceOld> competenceSet = skill.getCompetenceSet();
//            for (CompetenceOld competence : competenceSet) {
//                Set<JobCompetence> jobCompetenceSet = competence.getJobCompetenceSet();
//                for (JobCompetence jobCompetence : jobCompetenceSet) {
//                    Job job = jobCompetence.getJob();
//                    jobSet.add(job);
//                }
////            }
//        }
//        List<JobDTOOld.Info> jobInfo = new ArrayList<>();
//        Optional.ofNullable(jobSet)
//                .ifPresent(jobs ->
//                        jobs.forEach(job ->
//                                jobInfo.add(modelMapper.map(job, JobDTOOld.Info.class))
//                        ));
//        return jobInfo;
//    }


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
    public List<CompetenceDTOOld.Info> getCompetenceQuery(Long courseId) {
        List<CompetenceDTOOld.Info> compeInfoList = new ArrayList<>();
        //      --------------------------------------- By f.ghazanfari - start ---------------------------------------
//        List<CompetenceOld> competenceList = competenceDAO.findCompetenceByCourseId(courseId);
//        Optional.ofNullable(competenceList)
//                .ifPresent(competence ->
//                        competence.forEach(comp ->
//                                compeInfoList.add(modelMapper.map(comp, CompetenceDTOOld.Info.class))
//                        ));
//      --------------------------------------- By f.ghazanfari - end ---------------------------------------
        return compeInfoList;
    }

    //-------------------------------
    @Transactional
    @Override
    public List<CompetenceDTOOld.Info> getCompetence(Long courseId) {
        List<CompetenceDTOOld.Info> compeInfoList = new ArrayList<>();
        Set<CompetenceOld> competenceSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            Set<SkillGroup> skillGroupSet = skill.getSkillGroupSet();
            for (SkillGroup skillGroup : skillGroupSet) {
                Set<CompetenceOld> competenceSet1 = skillGroup.getCompetenceSet();
                for (CompetenceOld competence : competenceSet1) {
                    competenceSet.add(competence);
                }
            }
        }
        Optional.ofNullable(competenceSet)
                .ifPresent(competence ->
                        competence.forEach(comp ->
                                compeInfoList.add(modelMapper.map(comp, CompetenceDTOOld.Info.class))
                        ));
        return compeInfoList;
    }

    @Transactional
    @Override
    public List<PostDTO.Info> getPost(Long courseId) {
        Set<Post> postSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            Set<NeedAssessment> needAssessments = skill.getNeedAssessments();
            for (NeedAssessment needAssessment : needAssessments) {
                Post post = needAssessment.getPost();
                postSet.add(post);
            }
        }
        List<PostDTO.Info> postInfo = new ArrayList<>();
        Optional.ofNullable(postSet)
                .ifPresent(posts ->
                        posts.forEach(post ->
                                postInfo.add(modelMapper.map(post, PostDTO.Info.class))
                        ));
        return postInfo;
    }

    @Transactional
    @Override
    public List<SkillGroupDTO.Info> getSkillGroup(Long courseId) {
        Course one = courseDAO.getOne(courseId);
        Set<SkillGroup> set = new HashSet<>();
        List<SkillGroupDTO.Info> skillGroupInfo = new ArrayList<>();
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            Set<SkillGroup> skillGroupSet = skill.getSkillGroupSet();
            for (SkillGroup skillGroup : skillGroupSet) {
                set.add(skillGroup);
            }
        }
        Optional.ofNullable(set)
                .ifPresent(sets ->
                        sets.forEach(set1 ->
                                skillGroupInfo.add(modelMapper.map(set1, SkillGroupDTO.Info.class))
                        ));
        return skillGroupInfo;
    }

    @Transactional
    @Override
    public boolean checkForDelete(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        Set<Skill> skillSet = course.getSkillSet();
        Set<Tclass> tclasses = course.getTclassSet();
        List<Goal> goalSet = course.getGoalSet();
        return (((skillSet != null && skillSet.size() > 0) || (tclasses != null && tclasses.size() > 0)) ? false : true);
    }

    @Transactional
    @Override
    public void deletGoal(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        course.getGoalSet().clear();
    }

    @Transactional
    @Override
    public String getDomain(Long id) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course info = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        Float a = (float) 0;
        Float b = (float) 0;
        Float c = (float) 0;
        Float sumAll = (float) 0;
        List<Goal> goalSet = info.getGoalSet();
        for (Goal goal : goalSet) {
            Set<Syllabus> syllabusSet = goal.getSyllabusSet();
            for (Syllabus syllabus : syllabusSet) {
                Integer eDomainTypeId = syllabus.getEDomainTypeId();
                switch (eDomainTypeId) {
                    case 1:
                        a += syllabus.getPracticalDuration();
                        a += syllabus.getTheoreticalDuration();
                        break;
                    case 2:
                        b += syllabus.getTheoreticalDuration();
                        b += syllabus.getPracticalDuration();
                        break;
                    case 3:
                        c += syllabus.getTheoreticalDuration();
                        c += syllabus.getPracticalDuration();
                        break;
                }
                sumAll += syllabus.getTheoreticalDuration();
                sumAll += syllabus.getPracticalDuration();
            }
        }
        return "دانشی: " + round(a * 100 / (sumAll)) + "%     " + "نگرشی: " + round(c * 100 / (sumAll)) + "%    " + "مهارتی: " + round(b * 100 / (sumAll)) + "%";
    }


    @Transactional(readOnly = true)
    @Override
    public List<TeacherDTO.TeacherFullNameTuple> getTeachers(Long courseId) {
        final Optional<Course> optionalCourse = courseDAO.findById(courseId);
        final Course course = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        String minTeacherDegree = course.getMinTeacherDegree();
        List<EducationLevel> byTitleFa = educationLevelDAO.findByTitleFa(minTeacherDegree);
        EducationLevel educationLevel = byTitleFa.get(0);
        Long categoryId = course.getCategoryId();
        List<Teacher> teachers = teacherDAO.findByCategories_IdAndPersonality_EducationLevel_CodeGreaterThanEqual(categoryId, educationLevel.getCode());
        return modelMapper.map(teachers, new TypeToken<List<TeacherDTO.TeacherFullNameTuple>>() {
        }.getType());
    }


    @Transactional(readOnly = true)
    @Override
    public int updateCourseState(Long courseId, String workflowStatus, Integer workflowStatusCode) {
        return courseDAO.updateCourseState(courseId, workflowStatus, workflowStatusCode);
    }


    //---------------------heydari---------------------------
    //
    @Transactional()
    @Override
    public CourseDTO.Info updateEvaluation(Long id, CourseDTO.Update request) {
        Optional<Course> optionalCourse = courseDAO.findById(id);
        Course currentCourse = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        currentCourse.setEvaluation(request.getEvaluation());
        currentCourse.setBehavioralLevel(request.getBehavioralLevel());
        return modelMapper.map(courseDAO.save(currentCourse), CourseDTO.Info.class);

    }

    @Transactional
    @Override
    public List<CourseDTO.Info> getEvaluation(Long courseId) {
        List<Course> course = courseDAO.findAllById(courseId);
        return modelMapper.map(course, new TypeToken<List<CourseDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public CourseDTO.CourseGoals getCourseGoals(Long courseId) {
        Course course = courseDAO.findAllById(courseId).get(0);
        return modelMapper.map(course, CourseDTO.CourseGoals.class);
    }

}


