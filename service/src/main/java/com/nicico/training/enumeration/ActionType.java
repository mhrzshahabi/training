package com.nicico.training.enumeration;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ActionType {

    Get(1),
    List(2),
    Search(3),
    Create(4),
    CreateAll(5),
    Update(6),
    UpdateAll(7),
    Delete(8),
    DeleteAll(9);

    private final Integer id;

    public Integer getValue(ActionType actionType) {
        return actionType.id;
    }
}
