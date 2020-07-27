package com.nicico.training.service;/* com.nicico.training.service
@Author:jafari-h
@Date:5/28/2019
@Time:3:41 PM
*/

import com.nicico.copper.common.domain.criteria.SearchUtil;
import com.nicico.copper.common.dto.search.EOperator;
import com.nicico.copper.common.dto.search.SearchDTO;
import com.nicico.training.TrainingException;
import com.nicico.training.dto.CourseDTO;
import com.nicico.training.dto.GoalDTO;
import com.nicico.training.dto.SyllabusDTO;
import com.nicico.training.dto.TeacherDTO;
import com.nicico.training.iservice.IGoalService;
import com.nicico.training.model.Course;
import com.nicico.training.model.Goal;
import com.nicico.training.model.Institute;
import com.nicico.training.model.Teacher;
import com.nicico.training.repository.CourseDAO;
import com.nicico.training.repository.GoalDAO;
import com.nicico.training.repository.SyllabusDAO;
import lombok.RequiredArgsConstructor;
import org.modelmapper.ModelMapper;
import org.modelmapper.TypeToken;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

import static com.nicico.training.service.BaseService.makeNewCriteria;

@Service
@RequiredArgsConstructor
public class GoalService implements IGoalService {

    private final ModelMapper modelMapper;
    private final GoalDAO goalDAO;
    private final CourseDAO courseDAO;
    private final SyllabusDAO syllabusDAO;


    @Transactional(readOnly = true)
    @Override
    public GoalDTO.Info get(Long id) {
        final Optional<Goal> gById = goalDAO.findById(id);
        final Goal goal = gById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
        return modelMapper.map(goal, GoalDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public List<GoalDTO.Info> list() {
        final List<Goal> gAll = goalDAO.findAll();
        return modelMapper.map(gAll, new TypeToken<List<GoalDTO.Info>>() {
        }.getType());
    }

    @Transactional
    @Override
    public GoalDTO.Info create(GoalDTO.Create request, Long courseId) {
        final Goal goal = modelMapper.map(request, Goal.class);
        final Optional<Course> one = courseDAO.findById(courseId);
        final Course course = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.CourseNotFound));
        final Goal saved = goalDAO.saveAndFlush(goal);
        course.setHasGoal(true);
        course.getGoalSet().add(saved);
        return modelMapper.map(saved, GoalDTO.Info.class);
    }

    @Transactional
    @Override
    public GoalDTO.Info createWithoutCourse(GoalDTO.Create request) {
        final Goal goal = modelMapper.map(request, Goal.class);
        final Goal saved = goalDAO.saveAndFlush(goal);
        return modelMapper.map(saved, GoalDTO.Info.class);
    }

    @Transactional
    @Override
    public GoalDTO.Info update(Long id, GoalDTO.Update request) {
        final Optional<Goal> cById = goalDAO.findById(id);
        final Goal goal = cById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        Goal updating = new Goal();
        modelMapper.map(goal, updating);
        modelMapper.map(request, updating);
        return save(updating);
    }

    @Transactional
    @Override
    public void delete(Long id) {
        final Optional<Goal> one = goalDAO.findById(id);
        final Goal goal = one.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.SyllabusNotFound));
        List<Course> courses = goal.getCourseSet();
        if (courses.size() > 1) {
            return;
        }
        for (Course course : courses) {
            course.getGoalSet().remove(goal);
            if(course.getGoalSet().isEmpty())
                course.setHasGoal(false);
        }
//        Set<Syllabus> syllabusSet = goal.getSyllabusSet();
//        for (Syllabus syllabus : syllabusSet) {
//            syllabusDAO.delete(syllabus);
//        }
        goalDAO.delete(goal);
    }

    @Transactional
    @Override
    public void delete(GoalDTO.Delete request) {
        final List<Goal> gAllById = goalDAO.findAllById(request.getIds());
        goalDAO.deleteAll(gAllById);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GoalDTO.Info> search(SearchDTO.SearchRq request) {
        return SearchUtil.search(goalDAO, request, goal -> modelMapper.map(goal, GoalDTO.Info.class));
    }

    @Transactional
    @Override
    public List<SyllabusDTO.Info> getSyllabusSet(Long goalId) {
        final Optional<Goal> ssById = goalDAO.findById(goalId);
        final Goal goal = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
        List<SyllabusDTO.Info> syllabusInfoSet = new ArrayList<>();
        Optional.ofNullable(goal.getSyllabusSet())
                .ifPresent(syllabusSet ->
                        syllabusSet.forEach(syllabus ->
                                syllabusInfoSet.add(modelMapper.map(syllabus, SyllabusDTO.Info.class))
                        ));
        return syllabusInfoSet;
    }

    @Transactional
    @Override
    public List<CourseDTO.Info> getCourses(Long goalId) {
        final Optional<Goal> ssById = goalDAO.findById(goalId);
        final Goal goal = ssById.orElseThrow(() -> new TrainingException(TrainingException.ErrorType.GoalNotFound));
        List<CourseDTO.Info> courses = new ArrayList<>();
        Optional.ofNullable(goal.getCourseSet())
                .ifPresent(courseSet ->
                        courseSet.forEach(course ->
                                courses.add(modelMapper.map(course, CourseDTO.Info.class))
                        ));
        return courses;
    }

    // ------------------------------

    private GoalDTO.Info save(Goal goal) {
        final Goal saved = goalDAO.saveAndFlush(goal);
        return modelMapper.map(saved, GoalDTO.Info.class);
    }

    @Transactional(readOnly = true)
    @Override
    public SearchDTO.SearchRs<GoalDTO.Info> getGoalsByCategory(SearchDTO.SearchRq request, Long categoryID) {
        SearchDTO.CriteriaRq criteria = makeNewCriteria(null, null, EOperator.and, new ArrayList<>());
        criteria.getCriteria().add(makeNewCriteria("categoryId", categoryID, EOperator.equals, null));

        if (request.getCriteria() != null)
            criteria.getCriteria().add(request.getCriteria());
        request.setCriteria(criteria);

        return this.search(request);
    }
}
