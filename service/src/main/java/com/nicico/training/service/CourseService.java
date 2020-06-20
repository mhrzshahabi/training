package com.nicico.training.service;

import com.google.common.base.Joiner;
import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.grid.TotalResponse;
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
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import javax.persistence.EntityManager;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

import static java.lang.Math.round;

@Service
@RequiredArgsConstructor
public class CourseService implements ICourseService {

    private final ModelMapper modelMapper;
    private final GoalDAO goalDAO;
    private final EducationLevelDAO educationLevelDAO;
    private final TeacherDAO teacherDAO;
    private final SkillDAO skillDAO;
    private final CourseDAO courseDAO;
    private final TclassDAO tclassDAO;
    private final JobDAO jobDAO;
    private final PostDAO postDAO;
    private final CategoryDAO categoryDAO;
    private final SubcategoryDAO subCategoryDAO;
    private final TclassService tclassService;
    private final TeacherService teacherService;
    private final ParameterService parameterService;
    private final EnumsConverter.ETechnicalTypeConverter eTechnicalTypeConverter = new EnumsConverter.ETechnicalTypeConverter();
    private final EnumsConverter.ELevelTypeConverter eLevelTypeConverter = new EnumsConverter.ELevelTypeConverter();
    private final EnumsConverter.ERunTypeConverter eRunTypeConverter = new EnumsConverter.ERunTypeConverter();
    private final EnumsConverter.ETheoTypeConverter eTheoTypeConverter = new EnumsConverter.ETheoTypeConverter();
    private final MessageSource messageSource;
    @Autowired
    protected EntityManager entityManager;


    @Transactional(readOnly = true)
    @Override
    public CourseDTO.Info get(Long id) {
        return modelMapper.map(getCourse(id), CourseDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public Course getCourse(Long id) {
        final Optional<Course> cById = courseDAO.findById(id);
        return cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
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
        final Course course = getCourse(id);
        if (course.getPreCourseList() != null && !course.getPreCourseList().isEmpty()) {
            return modelMapper.map(course.getPreCourseList(), new TypeToken<List<CourseDTO.Info>>() {
            }.getType());
        }
        return new ArrayList<>();
    }

    @Transactional
    @Override
    public void setPreCourse(Long id, List<Long> preCourseListId) {
        final Course course = getCourse(id);
        if (course.getPreCourseList() == null) {
            course.setPreCourseList(new ArrayList<>());
        } else {
            course.getPreCourseList().clear();
        }
        course.getPreCourseList().addAll(courseDAO.findAllById(preCourseListId));
    }

    @Transactional
    @Override
    public void addPreCourse(CourseDTO.AddOrRemovePreCourse rq) {
        final Course course = getCourse(rq.getCourseId());
        if (course.getPreCourseList() == null) {
            course.setPreCourseList(new ArrayList<>());
        }
        course.getPreCourseList().addAll(courseDAO.findAllById(rq.getPreCoursesId()));
    }

    @Transactional
    @Override
    public void removePreCourse(CourseDTO.AddOrRemovePreCourse rq) {
        final Course course = getCourse(rq.getCourseId());
        if (course.getPreCourseList() == null) {
            throw (new TrainingException(TrainingException.ErrorType.NotFound));
        }
        course.getPreCourseList().removeAll(courseDAO.findAllById(rq.getPreCoursesId()));
    }

    @Transactional
    @Override
    public void updateHasSkill(Long id, Boolean hasSkill) {
        final Optional<Course> cById = courseDAO.findById(id);
        final Course course = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        if (hasSkill != null)
            course.setHasSkill(hasSkill);
        else
            course.setHasSkill(!course.getSkillSet().isEmpty());
        courseDAO.saveAndFlush(course);
    }

    @Transactional
    @Override
    public void setEqualCourse(Long id, List<String> equalCourseList) {
        final Course parentCourse = getCourse(id);
        if (parentCourse.getEqualCourses() == null) {
            parentCourse.setEqualCourses(new ArrayList<>());
        } else {
            parentCourse.getEqualCourses().clear();
        }
        for (String eqId : equalCourseList) {
            EqualCourse equalCourse = new EqualCourse();
            equalCourse.setCourseId(parentCourse.getId());
            equalCourse.setEqualAndList(courseDAO.findAllById(Arrays.stream(eqId.split("_")).map(Long::parseLong).collect(Collectors.toList())));
            parentCourse.getEqualCourses().add(equalCourse);
        }
    }

    @Transactional(readOnly = true)
    @Override
    public List<EqualCourseDTO.Info> equalCourseList(Long id) {
        final List<EqualCourseDTO.Info> listOut = new ArrayList<>();
        final Course parentCourse = getCourse(id);
        if (parentCourse.getEqualCourses() != null && !parentCourse.getEqualCourses().isEmpty()) {
            parentCourse.getEqualCourses().forEach(eqCourse -> {
                String idEQ1 = Joiner.on('_').join(eqCourse.getEqualAndList().stream().map(Course::getId).collect(Collectors.toList()));
                StringBuilder nameEQ1 = new StringBuilder();
                eqCourse.getEqualAndList().forEach(course -> {
                    nameEQ1.append(" و ").append("'").append(course.getTitleFa()).append("(").append(course.getCode()).append(")").append("'");
                });
                listOut.add(new EqualCourseDTO.Info().setId(eqCourse.getId()).setIdEC(idEQ1).setNameEC(nameEQ1.substring(3)));
            });
        }
        return listOut;
    }

    @Transactional
    @Override
    public void addEqualCourse(EqualCourseDTO.Add rq) {
        final Course course = getCourse(rq.getCourseId());
        if (course.getEqualCourses() == null) {
            course.setEqualCourses(new ArrayList<>());
        }
        if (rq.getId() == null) {
            course.getEqualCourses().add(new EqualCourse().setCourseId(rq.getCourseId()).setCourse(course).setEqualAndList(courseDAO.findAllById(rq.getEqualCoursesId())));
            return;
        }
        EqualCourse ec = course.getEqualCourses().stream().filter(equalCourse -> equalCourse.getId().equals(rq.getId())).findFirst().orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
        ec.getEqualAndList().addAll(courseDAO.findAllById(rq.getEqualCoursesId()));
    }

    @Transactional
    @Override
    public void removeEqualCourse(EqualCourseDTO.Remove rq) {
        final Course course = getCourse(rq.getCourseId());
        if (course.getEqualCourses() == null) {
            throw (new TrainingException(TrainingException.ErrorType.NotFound));
        }
        course.getEqualCourses().remove(course.getEqualCourses().stream().filter(equalCourse -> equalCourse.getId().equals(rq.getId())).findFirst().orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound)));
    }

    @Transactional
    @Override
    public CourseDTO.Info create(CourseDTO.Create request, HttpServletResponse response) {
        if (courseDAO.existsByTitleFa(request.getTitleFa())) {

            try {
                response.sendError(406, null);
                return null;
            } catch (IOException e) {

            }
        }
        Course course = modelMapper.map(request, Course.class);
        if (courseDAO.findByCodeEquals(course.getCode()).isEmpty()) {
//        if (true) {
            course.setELevelType(eLevelTypeConverter.convertToEntityAttribute(request.getELevelTypeId()));
            course.setERunType(eRunTypeConverter.convertToEntityAttribute(request.getERunTypeId()));
            course.setETheoType(eTheoTypeConverter.convertToEntityAttribute(request.getETheoTypeId()));
            course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(request.getETechnicalTypeId()));
            if (request.getMainObjectiveIds() != null && !request.getMainObjectiveIds().isEmpty())
                course.setHasSkill(true);
            else
                course.setHasSkill(false);
            Course course1 = courseDAO.save(course);
            if (request.getMainObjectiveIds() != null && !request.getMainObjectiveIds().isEmpty()) {
                Set<Skill> setSkill = new HashSet<>(skillDAO.findAllById(request.getMainObjectiveIds()));
                for (Skill skill : setSkill) {
                    skill.setCourseId(course1.getId());
                    skill.setCourseMainObjectiveId(course1.getId());
                    skillDAO.saveAndFlush(skill);
                }
            }
            return modelMapper.map(course1, CourseDTO.Info.class);
        } else
            return null;
    }

    @Transactional
    @Override
    public CourseDTO.Info update(Long id, Object request) {
        final Optional<Course> optionalCourse = courseDAO.findById(id);
        final Course currentCourse = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        CourseDTO.Update update = modelMapper.map(request, CourseDTO.Update.class);
        Course course = new Course();
        modelMapper.map(currentCourse, course);
        modelMapper.map(update, course);
        course.setETechnicalType(eTechnicalTypeConverter.convertToEntityAttribute(update.getETechnicalTypeId()));
        if (course.getGoalSet().isEmpty()) {
            course.setHasGoal(false);
        } else {
            course.setHasGoal(true);
        }
        course.setHasSkill(!course.getSkillSet().isEmpty());
        Course save = courseDAO.save(course);
        Set<Skill> savedSkills = save.getSkillMainObjectiveSet();
        Set<Skill> savingSkill = new HashSet<>(skillDAO.findAllById(update.getMainObjectiveIds()));
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
        SearchDTO.SearchRs<CourseDTO.Info> exitList = SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, CourseDTO.Info.class));
        return exitList;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CourseDTO.InfoTuple> searchInfoTuple(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<CourseDTO.InfoTuple> exitList = SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, CourseDTO.InfoTuple.class));
        return exitList;
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<CourseDTO.TupleInfo> safeSearch(SearchDTO.SearchRq request) {
        SearchDTO.SearchRs<CourseDTO.TupleInfo> exitList = SearchUtil.search(courseDAO, request, course -> modelMapper.map(course, CourseDTO.TupleInfo.class));

        return exitList;
    }

    @Transactional(readOnly = true)
//    @Override
    public <T> SearchDTO.SearchRs<T> searchGeneric(SearchDTO.SearchRq request, Class<T> infoType) {
        request = (request != null) ? request : new SearchDTO.SearchRq();
        return SearchUtil.search(courseDAO, request, e -> modelMapper.map(e, infoType));
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
    public List<GoalDTO.Info> getGoal(Long courseId) {
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
            if(goalSet.stream().map(Goal::getId).anyMatch(a->a.equals(aLong)))
            {
                continue;
            }
            final Optional<Goal> ById = goalDAO.findById(aLong);
            final Goal goal = ById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
            goalSet.add(goal);
        }
        one.setGoalSet(goalSet);
        if (!one.getGoalSet().isEmpty()) {
            one.setHasGoal(true);
        }
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
        if (one.getGoalSet().isEmpty())
            one.setHasGoal(false);
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
    public List<SkillDTO.Info> getMainObjective(Long courseId) {
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillMainObjectiveSet();
        List<SkillDTO.Info> skillInfo = new ArrayList<>();
        Optional.ofNullable(skillSet)
                .ifPresent(skills ->
                        skills.forEach(skill ->
                                skillInfo.add(modelMapper.map(skill, SkillDTO.Info.class))
                        ));
        return skillInfo;
    }

    @Transactional(readOnly = true)
    @Override
    public List<JobDTO.Info> getJob(Long courseId) {
        Set<Job> jobSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            List<NeedsAssessment> needAssessments = skill.getNeedsAssessments();
            for (NeedsAssessment needAssessment : needAssessments) {
                if (needAssessment.getObjectType().equalsIgnoreCase("job")) {
                    Optional<Job> jobOptional = jobDAO.findById((Long) needAssessment.getObjectId());
                    Job job = jobOptional.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.NotFound));
                    jobSet.add(job);
                }
            }
        }
        return modelMapper.map(jobSet, new TypeToken<List<JobDTO.Info>>() {
        }.getType());
    }

    @Transactional(readOnly = true)
    @Override
    public List<PostDTO.Info> getPost(Long courseId) {
        Set<Post> postSet = new HashSet<>();
        Course one = courseDAO.getOne(courseId);
        Set<Skill> skillSet = one.getSkillSet();
        for (Skill skill : skillSet) {
            List<NeedsAssessment> needAssessments = skill.getNeedsAssessments();
            for (NeedsAssessment needAssessment : needAssessments) {
                if (needAssessment.getObjectType().equalsIgnoreCase("post")) {
                    Optional<Post> postOptional = postDAO.findById((Long) needAssessment.getObjectId());
                    if (postOptional.isPresent()) {
//                    Post post = postOptional.orElseThrow(()->new TrainingException(TrainingException.ErrorType.NotFound));
                        postSet.add(postOptional.get());
                    }
                }
            }
        }
        return modelMapper.map(postSet, new TypeToken<List<PostDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public String getMaxCourseCode(String str) {
        List<Course> courseList = courseDAO.findByCodeStartingWith(str);
        Integer max = 0;
        if (courseList.size() == 0)
            return "0";
        for (Course course : courseList) {
            if (max < Integer.parseInt(course.getCode().substring(6)))
                max = Integer.parseInt(course.getCode().substring(6));
        }
        return String.valueOf(max);
    }

    //-------------------------------
//    @Transactional
//    @Override
//    public List<CompetenceDTOOld.Info> getCompetence(Long courseId) {
//        List<CompetenceDTOOld.Info> compeInfoList = new ArrayList<>();
//        Set<CompetenceOld> competenceSet = new HashSet<>();
//        Course one = courseDAO.getOne(courseId);
//        Set<Skill> skillSet = one.getSkillSet();
//        for (Skill skill : skillSet) {
//            Set<SkillGroup> skillGroupSet = skill.getSkillGroupSet();
//            for (SkillGroup skillGroup : skillGroupSet) {
//                Set<CompetenceOld> competenceSet1 = skillGroup.getCompetenceSet();
//                for (CompetenceOld competence : competenceSet1) {
//                    competenceSet.add(competence);
//                }
//            }
//        }
//        Optional.ofNullable(competenceSet)
//                .ifPresent(competence ->
//                        competence.forEach(comp ->
//                                compeInfoList.add(modelMapper.map(comp, CompetenceDTOOld.Info.class))
//                        ));
//        return compeInfoList;
//    }

//    @Transactional
//    @Override
//    public List<SkillGroupDTO.Info> getSkillGroup(Long courseId) {
//        Course one = courseDAO.getOne(courseId);
//        Set<SkillGroup> set = new HashSet<>();
//        List<SkillGroupDTO.Info> skillGroupInfo = new ArrayList<>();
//        Set<Skill> skillSet = one.getSkillSet();
//        for (Skill skill : skillSet) {
//            Set<SkillGroup> skillGroupSet = skill.getSkillGroupSet();
//            for (SkillGroup skillGroup : skillGroupSet) {
//                set.add(skillGroup);
//            }
//        }
//        Optional.ofNullable(set)
//                .ifPresent(sets ->
//                        sets.forEach(set1 ->
//                                skillGroupInfo.add(modelMapper.map(set1, SkillGroupDTO.Info.class))
//                        ));
//        return skillGroupInfo;
//    }

    @Transactional
    @Override
    public boolean checkForDelete(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
//        Set<Skill> skillSet = course.getSkillSet();
        Set<Tclass> tclasses = course.getTclassSet();
//        List<Goal> goalSet = course.getGoalSet();
//        return (((skillSet != null && skillSet.size() > 0) || (tclasses != null && tclasses.size() > 0)) ? false : true);
        return (!(tclasses != null && tclasses.size() > 0));
    }

    @Transactional
    @Override
    public void deletGoal(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        course.getGoalSet().clear();
    }

    @Transactional
//    @Override
    public void unAssignSkills(Long id) {
        Optional<Course> one = courseDAO.findById(id);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        Set<Skill> skillSet = course.getSkillSet();
        for (Skill skill : skillSet) {
            skill.setCourseMainObjectiveId(null);
            skill.setCourseId(null);
        }
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
    public List<TeacherDTO.TeacherFullNameTupleWithFinalGrade> getTeachers(Long courseId, Long teacherId) {
        final Optional<Course> optionalCourse = courseDAO.findById(courseId);
        final Course course = optionalCourse.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        String minTeacherDegree = course.getMinTeacherDegree();
        List<EducationLevel> byTitleFa = educationLevelDAO.findByTitleFa(minTeacherDegree);
        EducationLevel educationLevel = byTitleFa.get(0);
//        Long categoryId = course.getCategoryId();
        List<Teacher> teachers = teacherDAO.findByCategories_IdAndPersonality_EducationLevel_CodeGreaterThanEqualAndInBlackList(course.getCategoryId(), educationLevel.getCode(), false);
        List<TeacherDTO.TeacherFullNameTupleWithFinalGrade> sendingList = new ArrayList<>();
        Comparator<Tclass> tclassComparator = Comparator.comparing(Tclass::getEndDate);

        Category category = categoryDAO.findById(course.getCategoryId()).orElse(null);
        Subcategory subCategory = subCategoryDAO.findById(course.getSubCategoryId()).orElse(null);
        TotalResponse<ParameterValueDTO.Info> parameters = parameterService.getByCode("ClassConfig");
        List<ParameterValueDTO.Info> parameterValues = parameters.getResponse().getData();

        if (!teachers.isEmpty()) {

            for (Teacher teacher : teachers) {
                Map<String, Object> map = teacherService.evaluateTeacher(teacher, category, subCategory, parameterValues);
                if (map.get("pass_status").equals("رد")) {
                    continue;
                }
                List<Tclass> tclassList = tclassDAO.findByCourseAndTeacher(course, teacher);
                TeacherDTO.TeacherFullNameTupleWithFinalGrade teacherDTO = modelMapper.map(teacher, TeacherDTO.TeacherFullNameTupleWithFinalGrade.class);
                Optional<Tclass> max = tclassList.stream().max(tclassComparator);
                if (max.isPresent()) {
                    Tclass tclass = max.get();
                    teacherDTO.setGrade(String.valueOf(tclassService.getStudentsGradeToTeacher(tclass.getClassStudents())));
                }
                sendingList.add(teacherDTO);
            }
        }

        if (teacherId != 0 && sendingList.stream().filter(p -> p.getId() == teacherId).count() == 0) {
            Teacher teacher = teacherDAO.findById(teacherId).orElse(null);

            if (teacher != null) {
                List<Tclass> tclassList = tclassDAO.findByCourseAndTeacher(course, teacher);
                TeacherDTO.TeacherFullNameTupleWithFinalGrade teacherDTO = modelMapper.map(teacher, TeacherDTO.TeacherFullNameTupleWithFinalGrade.class);
                Optional<Tclass> max = tclassList.stream().max(tclassComparator);
                if (max.isPresent()) {
                    Tclass tclass = max.get();
                    teacherDTO.setGrade(String.valueOf(tclassService.getStudentsGradeToTeacher(tclass.getClassStudents())));
                }
                sendingList.add(teacherDTO);
            }
        }

        return sendingList;
//        return modelMapper.map(teachers, new TypeToken<List<TeacherDTO.TeacherFullNameTuple>>() {
//        }.getType());
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

    //----------------------------------------------------------------------
    @Transactional
    @Override
    public List<CourseDTO.courseWithOutTeacher> courseWithOutTeacher(String startDate, String endDate) {
        StringBuilder stringBuilder = new StringBuilder().append("SELECT  tbl_course.id,tbl_course.c_code ,tbl_course.c_title_fa  FROM  tbl_course WHERE tbl_course.id NOT IN (SELECT DISTINCT  tbl_class.f_course  FROM  tbl_class   WHERE   tbl_class.c_start_date >= :startDate    AND   tbl_class.c_end_date <= :endDate )");
        List<Object> list = new ArrayList<>();
        list = (List<Object>) entityManager.createNativeQuery(stringBuilder.toString())
                .setParameter("startDate", startDate)
                .setParameter("endDate", endDate).getResultList();
        List<CourseDTO.courseWithOutTeacher> courseWithOutTeacherList = new ArrayList<>();
        if (list != null) {
            for (int i = 0; i < list.size(); i++) {
                Object[] arr = (Object[]) list.get(i);
                courseWithOutTeacherList.add(new CourseDTO.courseWithOutTeacher(Long.valueOf(arr[0].toString()), (arr[1] == null ? "" : arr[1].toString()), (arr[2] == null ? "" : arr[2].toString())));
            }
        }
        return (modelMapper.map(courseWithOutTeacherList, new TypeToken<List<CourseDTO.courseWithOutTeacher>>() {
        }.getType()));
    }

    //----------------------------------------------------------------------


}


